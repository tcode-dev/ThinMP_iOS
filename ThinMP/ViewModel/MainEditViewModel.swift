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
    @Published var settings = MainSettings.empty
    @Published var shortcuts: [ShortcutModel] = []
    /// 1 回目の読み込みが終わったか。終わるまでは保存を受け付けない
    @Published private(set) var isLoaded = false

    private let mainService: MainServiceProtocol
    private let shortcutRepository: ShortcutRepositoryProtocol
    private let loadTask = LoadTask()

    init(
        mainService: MainServiceProtocol = MainService(),
        shortcutRepository: ShortcutRepositoryProtocol = ShortcutRepository()
    ) {
        self.mainService = mainService
        self.shortcutRepository = shortcutRepository
    }

    @discardableResult
    func load() -> Task<Void, Never> {
        return loadTask.run { [mainService] in
            await (mainService.loadSettings(), mainService.findShortcuts())
        } apply: { [weak self] settings, shortcuts in
            self?.settings = settings
            self?.shortcuts = shortcuts
            self?.isLoaded = true
        }
    }

    /// 表示設定とショートカットの並び順 / 削除を保存する
    /// 読み込み前に呼ばれたら何もしない(MainSettings.empty と空のショートカットで上書きしてしまう)
    func save() {
        guard isLoaded else {
            return
        }

        mainService.save(settings: settings)
        shortcutRepository.update(shortcutIds: shortcuts.map { $0.shortcutId })
    }
}
