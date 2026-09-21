//
//  MainEditViewModel.swift
//  ThinMP
//
//  Created by tk on 2021/06/19.
//

import MediaPlayer

@MainActor
class MainEditViewModel: ObservableObject {
    @Published var menus: [MenuModel] = []
    @Published var shortcutMenu = MenuModel(primaryText: "", visibility: true)
    @Published var recentlyMenu = MenuModel(primaryText: "", visibility: true)
    @Published var shortcuts: [ShortcutModel] = []
    @Published var albums: [AlbumModel] = []

    private let mainService: MainServiceProtocol

    init(mainService: MainServiceProtocol = MainService()) {
        self.mainService = mainService
    }

    @discardableResult
    func load() -> Task<Void, Never> {
        Task {
            menus = mainService.getMainMenus()
            shortcutMenu = mainService.getShortcutMenu()
            recentlyMenu = mainService.getRecentlyMenu()
            shortcuts = await mainService.findShortcuts()
            albums = await mainService.findRecentlyAlbums()
        }
    }
}
