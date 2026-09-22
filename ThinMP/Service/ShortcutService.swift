//
//  ShortcutService.swift
//  ThinMP
//
//  Created by tk on 2021/06/24.
//

struct ShortcutService: ShortcutServiceProtocol {
    private let shortcutRepository: ShortcutRepositoryProtocol
    private let shortcutRegister: ShortcutRegisterProtocol
    private let artistDetailService: ArtistDetailServiceProtocol
    private let albumDetailService: AlbumDetailServiceProtocol
    private let playlistDetailService: PlaylistDetailServiceProtocol

    init(
        shortcutRepository: ShortcutRepositoryProtocol = ShortcutRepository(),
        shortcutRegister: ShortcutRegisterProtocol = ShortcutRegister(),
        artistDetailService: ArtistDetailServiceProtocol = ArtistDetailService(),
        albumDetailService: AlbumDetailServiceProtocol = AlbumDetailService(),
        playlistDetailService: PlaylistDetailServiceProtocol = PlaylistDetailService()
    ) {
        self.shortcutRepository = shortcutRepository
        self.shortcutRegister = shortcutRegister
        self.artistDetailService = artistDetailService
        self.albumDetailService = albumDetailService
        self.playlistDetailService = playlistDetailService
    }

    func findAll() async -> [ShortcutModel] {
        let shortcuts = shortcutRepository.findAll()
        let grouping = Dictionary(grouping: shortcuts) { $0.type }
            .mapValues { $0.map { $0.itemId } }

        var shortcutDictionary: [ShortcutType: [DetailProtocol]] = [.ARTIST: [], .ALBUM: [], .PLAYLIST: []]

        // アーティスト / アルバムはライブラリを舐めるのでバックグラウンドで解決する
        // プレイリストは PlaylistDetailService 側で同じことをしている
        if let artistIds = grouping[.ARTIST] {
            shortcutDictionary[.ARTIST] = await Task.detached(priority: .userInitiated) { [artistDetailService] in
                artistDetailService.findByIds(artistIds: artistIds.map { $0.artistId })
            }.value
        }

        if let albumIds = grouping[.ALBUM] {
            shortcutDictionary[.ALBUM] = await Task.detached(priority: .userInitiated) { [albumDetailService] in
                albumDetailService.findByIds(albumIds: albumIds.map { $0.albumId })
            }.value
        }

        if let playlistIds = grouping[.PLAYLIST] {
            shortcutDictionary[.PLAYLIST] = await playlistDetailService.findByIds(playlistIds: playlistIds.map { $0.playlistId })
        }

        let shortcutModels = shortcuts
            .filter { shortcut in shortcutDictionary[shortcut.type]!.contains(where: { $0.shortcutId == shortcut.itemId.id }) }
            .map { shortcut -> ShortcutModel in
                let itemModel = shortcutDictionary[shortcut.type]!.first { $0.shortcutId == shortcut.itemId.id }!

                return ShortcutModel(shortcutId: shortcut.shortcutId, itemId: shortcut.itemId, type: shortcut.type.rawValue, primaryText: itemModel.primaryText, artwork: itemModel.artwork)
            }

        // 端末から削除されたアーティスト、アルバム、プレイリストのショートカットは取り除いて読み直す
        if !validation(shortcuts: shortcuts, shortcutModels: shortcutModels) {
            fix(shortcutModels: shortcutModels)

            return await findAll()
        }

        return shortcutModels
    }

    private func validation(shortcuts: [ShortcutEntity], shortcutModels: [ShortcutModel]) -> Bool {
        return shortcuts.count == shortcutModels.count
    }

    private func fix(shortcutModels: [ShortcutModel]) {
        shortcutRegister.update(shortcutIds: shortcutModels.map { $0.shortcutId })
    }
}
