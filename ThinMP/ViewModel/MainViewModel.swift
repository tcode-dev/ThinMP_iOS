//
//  MainViewModel.swift
//  ThinMP
//
//  Created by tk on 2021/05/07.
//

import MediaPlayer

@MainActor
class MainViewModel: ObservableObject {
    @Published var menus: [MenuModel] = []
    @Published var shortcutMenu = MenuModel(primaryText: "", visibility: false)
    @Published var recentlyMenu = MenuModel(primaryText: "", visibility: false)
    @Published var shortcuts: [ShortcutModel] = []
    @Published var albums: [AlbumModel] = []

    // SwiftData の ModelContext はスレッドセーフではなく、全 Repository が同じ context を共有しているので
    // メインアクター上で実行する(Task.detached でバックグラウンドに逃がさない)
    func load() {
        Task {
            let mainService = MainService()
            let shortcutMenu = mainService.getShortcutMenu()
            let recentlyMenu = mainService.getRecentlyMenu()

            menus = mainService.getMainMenus()
            self.shortcutMenu = shortcutMenu
            self.recentlyMenu = recentlyMenu
            shortcuts = shortcutMenu.visibility ? mainService.findShortcuts() : []
            albums = recentlyMenu.visibility ? mainService.findRecentlyAlbums() : []
        }
    }
}
