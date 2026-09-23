//
//  ShortcutService.swift
//  ThinMP
//
//  Created by tk on 2021/06/24.
//

struct ShortcutService: ShortcutServiceProtocol {
    private let shortcutRepository: ShortcutRepositoryProtocol
    private let artistDetailService: ArtistDetailServiceProtocol
    private let albumDetailService: AlbumDetailServiceProtocol
    private let playlistDetailService: PlaylistDetailServiceProtocol

    init(
        shortcutRepository: ShortcutRepositoryProtocol = ShortcutRepository(),
        artistDetailService: ArtistDetailServiceProtocol = ArtistDetailService(),
        albumDetailService: AlbumDetailServiceProtocol = AlbumDetailService(),
        playlistDetailService: PlaylistDetailServiceProtocol = PlaylistDetailService()
    ) {
        self.shortcutRepository = shortcutRepository
        self.artistDetailService = artistDetailService
        self.albumDetailService = albumDetailService
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
        let albums = albumIds.isEmpty ? [] : await albumDetailService.findByIds(albumIds: albumIds)
        let playlists = playlistIds.isEmpty ? [] : await playlistDetailService.findByIds(playlistIds: playlistIds)

        let artistById = artists.keyed { $0.artistId }
        let albumById = albums.keyed { $0.albumId }
        let playlistById = playlists.keyed { $0.playlistId }

        // 端末に存在しないものは落とす
        var missingTargets: [ShortcutTarget] = []
        let shortcutModels = shortcuts.compactMap { shortcut -> ShortcutModel? in
            let item: MediaProtocol? = switch shortcut.target {
            case .artist(let artistId): artistById[artistId]
            case .album(let albumId): albumById[albumId]
            case .playlist(let playlistId): playlistById[playlistId]
            }

            guard let item else {
                missingTargets.append(shortcut.target)

                return nil
            }

            return ShortcutModel(shortcutId: shortcut.shortcutId, target: shortcut.target, primaryText: item.primaryText, artwork: item.artwork)
        }

        // 端末から削除されたアーティスト、アルバム、プレイリストのショートカットは、それだけ取り除く
        // 一覧ごと上書きすると、走査中に(別のページで)追加されたショートカットまで消える
        for target in missingTargets {
            shortcutRepository.delete(target: target)
        }

        return shortcutModels
    }
}
