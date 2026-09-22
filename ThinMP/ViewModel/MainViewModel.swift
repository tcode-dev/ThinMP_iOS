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
    /// 直前の load を打ち切るために保持する。古い結果が新しい結果を上書きしないようにする
    private var loadTask: Task<Void, Never>?

    init(mainService: MainServiceProtocol = MainService()) {
        self.mainService = mainService
    }

    @discardableResult
    func load() -> Task<Void, Never> {
        loadTask?.cancel()

        let task = Task {
            let menus = mainService.getMainMenus()
            let shortcutMenu = mainService.getShortcutMenu()
            let recentlyMenu = mainService.getRecentlyMenu()
            let shortcuts = shortcutMenu.visibility ? await mainService.findShortcuts() : []
            let albums = recentlyMenu.visibility ? await mainService.findRecentlyAlbums() : []

            if Task.isCancelled { return }

            self.menus = menus
            self.shortcutMenu = shortcutMenu
            self.recentlyMenu = recentlyMenu
            self.shortcuts = shortcuts
            self.albums = albums
        }

        loadTask = task

        return task
    }
}
