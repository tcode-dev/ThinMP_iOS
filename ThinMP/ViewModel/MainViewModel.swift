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

    private let mainService: MainServiceProtocol

    init(mainService: MainServiceProtocol = MainService()) {
        self.mainService = mainService
    }

    @discardableResult
    func load() -> Task<Void, Never> {
        Task {
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
