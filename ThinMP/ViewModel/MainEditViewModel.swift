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

    // SwiftData の ModelContext はスレッドセーフではなく、全 Repository が同じ context を共有しているので
    // メインアクター上で実行する(Task.detached でバックグラウンドに逃がさない)
    @discardableResult
    func load() -> Task<Void, Never> {
        Task {
            menus = mainService.getMainMenus()
            shortcutMenu = mainService.getShortcutMenu()
            recentlyMenu = mainService.getRecentlyMenu()
            shortcuts = mainService.findShortcuts()
            albums = mainService.findRecentlyAlbums()
        }
    }
}
