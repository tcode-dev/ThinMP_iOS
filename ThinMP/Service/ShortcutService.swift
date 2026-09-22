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

        let artistById = Dictionary(artists.map { ($0.artistId, $0) }, uniquingKeysWith: { first, _ in first })
        let albumById = Dictionary(albums.map { ($0.albumId, $0) }, uniquingKeysWith: { first, _ in first })
        let playlistById = Dictionary(playlists.map { ($0.playlistId, $0) }, uniquingKeysWith: { first, _ in first })

        // 端末に存在しないものは落とす(下で数が減ったことを検出する)
        let shortcutModels = shortcuts.compactMap { shortcut -> ShortcutModel? in
            let item: MediaProtocol?

            switch shortcut.target {
            case .artist(let artistId): item = artistById[artistId]
            case .album(let albumId): item = albumById[albumId]
            case .playlist(let playlistId): item = playlistById[playlistId]
            }

            guard let item else {
                return nil
            }

            return ShortcutModel(shortcutId: shortcut.shortcutId, target: shortcut.target, primaryText: item.primaryText, artwork: item.artwork)
        }

        // 端末から削除されたアーティスト、アルバム、プレイリストのショートカットは取り除いて保存する
        if shortcutModels.count != shortcuts.count {
            shortcutRepository.update(shortcutIds: shortcutModels.map { $0.shortcutId })
        }

        return shortcutModels
    }
}
