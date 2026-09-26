//
//  MainViewModel.swift
//  ThinMP
//
//  Created by tk on 2021/05/07.
//

import Observation

@Observable
final class MainViewModel {
    private(set) var settings = MainSettings.empty
    private(set) var shortcuts: [ShortcutModel] = []
    private(set) var albums: [AlbumModel] = []

    private let mainService: MainServiceProtocol
    private let loadTask = LoadTask()

    init(mainService: MainServiceProtocol = MainService()) {
        self.mainService = mainService
    }

    /// 非表示にしているセクションは読まない
    func load() async {
        await loadTask.run {
            let settings = mainService.loadSettings()
            let shortcuts = settings.isShortcutVisible ? await mainService.findShortcuts() : []
            let albums = settings.isRecentlyVisible ? await mainService.findRecentlyAlbums() : []

            return (settings, shortcuts, albums)
        } apply: { settings, shortcuts, albums in
            self.settings = settings
            self.shortcuts = shortcuts
            self.albums = albums
        }
    }
}
