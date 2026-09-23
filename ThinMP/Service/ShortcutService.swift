//
//  ShortcutService.swift
//  ThinMP
//
//  Created by tk on 2021/06/24.
//

struct ShortcutService: ShortcutServiceProtocol {
    private let shortcutRepository: ShortcutRepositoryProtocol
    private let artistDetailService: ArtistDetailServiceProtocol
    private let albumsService: AlbumsServiceProtocol
    private let playlistDetailService: PlaylistDetailServiceProtocol

    init(
        shortcutRepository: ShortcutRepositoryProtocol = ShortcutRepository(),
        artistDetailService: ArtistDetailServiceProtocol = ArtistDetailService(),
        albumsService: AlbumsServiceProtocol = AlbumsService(),
        playlistDetailService: PlaylistDetailServiceProtocol = PlaylistDetailService()
    ) {
        self.shortcutRepository = shortcutRepository
        self.artistDetailService = artistDetailService
        self.albumsService = albumsService
        self.playlistDetailService = playlistDetailService
    }

    func findAll() async -> [ShortcutModel] {
        let shortcuts = shortcutRepository.findAll()
        var artistIds: [ArtistId] = []
        var albumIds: [AlbumId] = []
        var playlistIds: [PlaylistId] = []

        for shortcut in shortcuts {
            switch shortcut.target {
            case .artist(let artistId): artistIds.append(artistId)
            case .album(let albumId): albumIds.append(albumId)
            case .playlist(let playlistId): playlistIds.append(playlistId)
            }
        }

        // 種別ごとにまとめて 1 回で解決する。ライブラリのスキャンは各 Service がバックグラウンドで行う
        let artists = artistIds.isEmpty ? [] : await artistDetailService.findByIds(artistIds: artistIds)
        let albums = albumIds.isEmpty ? [] : await albumsService.findByIds(albumIds: albumIds)
        let playlists = playlistIds.isEmpty ? [] : await playlistDetailService.findByIds(playlistIds: playlistIds)

        let artistById = artists.keyed { $0.artistId }
        let albumById = albums.keyed { $0.albumId }
        let playlistById = playlists.keyed { $0.playlistId }

        // 端末に存在しないものは落とす
        let shortcutModels = shortcuts.compactMap { shortcut -> ShortcutModel? in
            let item: MediaProtocol? = switch shortcut.target {
            case .artist(let artistId): artistById[artistId]
            case .album(let albumId): albumById[albumId]
            case .playlist(let playlistId): playlistById[playlistId]
            }

            guard let item else {
                return nil
            }

            return ShortcutModel(shortcutId: shortcut.shortcutId, target: shortcut.target, primaryText: item.primaryText, artwork: item.artwork)
        }

        // 端末に無いアーティストとアルバムのうち、クラウドにも無いものだけを消す対象にする
        // クラウドにしか無いもの(端末から外されただけのもの)は表示しないが、ダウンロードし直せば戻るように残す
        let missingArtistIds = artistIds.filter { artistById[$0] == nil }
        let missingAlbumIds = albumIds.filter { albumById[$0] == nil }
        let deletedArtistIds: Set<ArtistId> = missingArtistIds.isEmpty ? [] : await artistDetailService.findDeletedIds(artistIds: missingArtistIds)
        let deletedAlbumIds: Set<AlbumId> = missingAlbumIds.isEmpty ? [] : await albumsService.findDeletedIds(albumIds: missingAlbumIds)

        // 端末から削除されたアーティスト、アルバム、プレイリストのショートカットは、それだけ取り除く
        // 一覧ごと上書きすると、走査中に(別のページで)追加されたショートカットまで消える
        for shortcut in shortcuts {
            let isDeleted = switch shortcut.target {
            case .artist(let artistId): deletedArtistIds.contains(artistId)
            case .album(let albumId): deletedAlbumIds.contains(albumId)
            case .playlist(let playlistId): playlistById[playlistId] == nil
            }

            if isDeleted {
                shortcutRepository.delete(target: shortcut.target)
            }
        }

        return shortcutModels
    }
}
