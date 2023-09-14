//
//  MainViewModel.swift
//  ThinMP
//
//  Created by tk on 2021/05/07.
//

import MediaPlayer

class MainViewModel: ObservableObject {
    @Published var menus: [MenuModel] = []
    @Published var shortcutMenu = MenuModel(primaryText: "", visibility: false)
    @Published var recentlyMenu = MenuModel(primaryText: "", visibility: false)
    @Published var shortcuts: [ShortcutModel] = []
    @Published var albums: [AlbumModel] = []

    func load() {
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
