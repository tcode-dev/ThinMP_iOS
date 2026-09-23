//
//  MainEditViewModel.swift
//  ThinMP
//
//  Created by tk on 2021/06/19.
//

import Combine

@MainActor
final class MainEditViewModel: ObservableObject {
    /// 編集ページでそのまま書き換え、save() でまとめて保存する内容
    /// 表示設定とショートカットは一緒に読み込むので、片方だけある状態を作らないように 1 つにまとめる
    struct Draft {
        var settings: MainSettings
        var shortcuts: [ShortcutModel]
    }

    /// 読み込む前は nil。nil のあいだは保存を受け付けない
    @Published var draft: Draft?

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
            self?.draft = Draft(settings: settings, shortcuts: shortcuts)
        }
    }

    /// 表示設定とショートカットの並び順 / 削除を保存する
    /// 読み込み前に呼ばれたら何もしない(空の設定とショートカットで上書きしてしまう)
    func save() {
        guard let draft else {
            return
        }

        mainService.save(settings: draft.settings)
        shortcutRepository.update(shortcutIds: draft.shortcuts.map { $0.shortcutId })
    }
}
