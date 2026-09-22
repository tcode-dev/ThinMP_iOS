//
//  MainService.swift
//  ThinMP
//
//  Created by tk on 2021/06/02.
//

import MediaPlayer

struct MainService: MainServiceProtocol {
    private let ALBUM_COUNT = 20
    private let albumRepository: AlbumRepositoryProtocol
    private let shortcutService: ShortcutServiceProtocol

    init(
        albumRepository: AlbumRepositoryProtocol = AlbumRepository(),
        shortcutService: ShortcutServiceProtocol = ShortcutService()
    ) {
        self.albumRepository = albumRepository
        self.shortcutService = shortcutService
    }

    func findRecentlyAlbums() async -> [AlbumModel] {
        return await Task.detached(priority: .userInitiated) { [albumRepository, ALBUM_COUNT] in
            albumRepository.findRecently(count: ALBUM_COUNT)
        }.value
    }

    func findShortcuts() async -> [ShortcutModel] {
        return await shortcutService.findAll()
    }

    func getMainMenus() -> [MenuModel] {
        let config = MainMenuConfig()

        return config.getList()
    }

    func getShortcutMenu() -> MenuModel {
        let config = MainSectionConfig()

        return config.getShortcut()
    }

    func getRecentlyMenu() -> MenuModel {
        let config = MainSectionConfig()

        return config.getRecently()
    }
}
