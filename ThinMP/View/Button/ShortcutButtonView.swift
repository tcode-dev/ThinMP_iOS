//
//  ShortcutButtonView.swift
//  ThinMP
//
//  Created by tk on 2021/05/08.
//

import SwiftUI

/// コンテキストメニューに置く、ショートカットの登録 / 解除ボタン
struct ShortcutButtonView: View {
    let target: ShortcutTarget
    /// 登録 / 解除のあとに呼ばれる(一覧の再読み込みなど)
    var onToggle: () -> Void = {}
    private let repository: ShortcutRepositoryProtocol = ShortcutRepository()

    var body: some View {
        RegisterToggleButtonView(
            addLabel: LabelConstant.addShortcut,
            removeLabel: LabelConstant.removeShortcut,
            exists: { repository.exists(target: target) },
            toggle: { repository.toggle(target: target) },
            onToggle: onToggle
        )
    }
}
