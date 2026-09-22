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
    private let loadTask = LoadTask()

    init(mainService: MainServiceProtocol = MainService()) {
        self.mainService = mainService
    }

    @discardableResult
    func load() -> Task<Void, Never> {
        return loadTask.run { [mainService] in
            (mainService.getSettings(), await mainService.findShortcuts())
        } apply: { [weak self] settings, shortcuts in
            self?.settings = settings
            self?.shortcuts = shortcuts
        }
    }

    /// 表示設定とショートカットの並び順 / 削除を保存する
    func save() {
        mainService.save(settings: settings)
        mainService.update(shortcutIds: shortcuts.map { $0.shortcutId })
    }
}
