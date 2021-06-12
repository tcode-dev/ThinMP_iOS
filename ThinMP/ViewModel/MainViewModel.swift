//
//  MainViewModel.swift
//  ThinMP
//
//  Created by tk on 2021/05/07.
//

import MediaPlayer

class MainViewModel: ViewModelProtocol {
    @Published var menus: [MenuModel] = []
    @Published var shortcutMenu: MenuModel = MenuModel(primaryText: "", visibility: false)
    @Published var recentlyMenu: MenuModel = MenuModel(primaryText: "", visibility: false)
    @Published var shortcuts: [ShortcutModel] = []
    @Published var albums: [AlbumModel] = []

    func fetch() {
        let mainService = MainService()
        let menus = mainService.getMainMenus()
        let shortcutMenu = mainService.getShortcutMenu()
        let recentlyMenu = mainService.getRecentlyMenu()
        let shortcuts = shortcutMenu.visibility ? mainService.findShortcuts() : []
        let albums = recentlyMenu.visibility ? mainService.findRecentlyAlbums() : []

        DispatchQueue.main.async {
            self.menus = menus
            self.shortcutMenu = shortcutMenu
            self.recentlyMenu = recentlyMenu
            self.shortcuts = shortcuts
            self.albums = albums
        }
    }
}
