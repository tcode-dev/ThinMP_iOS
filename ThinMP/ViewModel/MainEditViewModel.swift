//
//  MainEditViewModel.swift
//  ThinMP
//
//  Created by tk on 2021/06/19.
//

import Combine

@MainActor
class MainEditViewModel: ObservableObject {
    /// 編集ページでそのまま書き換え、save() で保存する
    @Published var settings = MainSettings(menus: [], isShortcutVisible: true, isRecentlyVisible: true)
    @Published var shortcuts: [ShortcutModel] = []

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
            let shortcuts = await mainService.findShortcuts()

            if Task.isCancelled { return }

            self.settings = settings
            self.shortcuts = shortcuts
        }

        loadTask = task

        return task
    }

    func save() {
        mainService.save(settings: settings)
    }
}
