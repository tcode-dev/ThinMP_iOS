//
//  MainService.swift
//  ThinMP
//
//  Created by tk on 2021/06/02.
//

import MediaPlayer

struct MainService: MainServiceProtocol {
    private let ALBUM_COUNT = 20

    func findRecentlyAlbums() -> [AlbumModel] {
        let repository = AlbumRepository()

        return repository.findRecently(count: ALBUM_COUNT)
    }

    func findShortcuts() -> [ShortcutModel] {
        let service = ShortcutService()

        return service.findAll()
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
