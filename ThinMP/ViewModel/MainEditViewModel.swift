//
//  MainEditViewModel.swift
//  ThinMP
//
//  Created by tk on 2021/06/19.
//

import MediaPlayer

class MainEditViewModel: ObservableObject {
    @Published var menus: [MenuModel] = []
    @Published var shortcutMenu = MenuModel(primaryText: "", visibility: true)
    @Published var recentlyMenu = MenuModel(primaryText: "", visibility: true)
    @Published var shortcuts: [ShortcutModel] = []
    @Published var albums: [AlbumModel] = []

    func load() {
        let mainService = MainService()
        let menus = mainService.getMainMenus()
        let shortcutMenu = mainService.getShortcutMenu()
        let recentlyMenu = mainService.getRecentlyMenu()
        let shortcuts = mainService.findShortcuts()
        let albums = mainService.findRecentlyAlbums()

        DispatchQueue.main.async {
            self.menus = menus
            self.shortcutMenu = shortcutMenu
            self.recentlyMenu = recentlyMenu
            self.shortcuts = shortcuts
            self.albums = albums
        }
    }
}
