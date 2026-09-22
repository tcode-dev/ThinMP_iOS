//
//  MainViewModel.swift
//  ThinMP
//
//  Created by tk on 2021/05/07.
//

import Combine

@MainActor
class MainViewModel: ObservableObject {
    @Published var settings = MainSettings(menus: [], isShortcutVisible: false, isRecentlyVisible: false)
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
            let settings = mainService.getSettings()
            let shortcuts = settings.isShortcutVisible ? await mainService.findShortcuts() : []
            let albums = settings.isRecentlyVisible ? await mainService.findRecentlyAlbums() : []

            if Task.isCancelled { return }

            self.settings = settings
            self.shortcuts = shortcuts
            self.albums = albums
        }

        loadTask = task

        return task
    }
}
