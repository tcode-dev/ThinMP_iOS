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

    func findRecentlyAlbums() -> [AlbumModel] {
        return albumRepository.findRecently(count: ALBUM_COUNT)
    }

    func findShortcuts() -> [ShortcutModel] {
        return shortcutService.findAll()
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
