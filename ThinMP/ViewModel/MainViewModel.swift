//
//  MainViewModel.swift
//  ThinMP
//
//  Created by tk on 2021/05/07.
//

import Combine

@MainActor
final class MainViewModel: ObservableObject {
    @Published var settings = MainSettings.empty
    @Published var shortcuts: [ShortcutModel] = []
    @Published var albums: [AlbumModel] = []

    private let mainService: MainServiceProtocol
    private let loadTask = LoadTask()

    init(mainService: MainServiceProtocol = MainService()) {
        self.mainService = mainService
    }

    /// 非表示にしているセクションは読まない
    @discardableResult
    func load() -> Task<Void, Never> {
        return loadTask.run { [mainService] in
            let settings = mainService.loadSettings()
            let shortcuts = settings.isShortcutVisible ? await mainService.findShortcuts() : []
            let albums = settings.isRecentlyVisible ? await mainService.findRecentlyAlbums() : []

            return (settings, shortcuts, albums)
        } apply: { [weak self] settings, shortcuts, albums in
            self?.settings = settings
            self?.shortcuts = shortcuts
            self?.albums = albums
        }
    }
}
