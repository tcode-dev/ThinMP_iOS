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
    var callback: () -> Void = {}
    var repository: ShortcutRepositoryProtocol = ShortcutRepository()

    var body: some View {
        RegisterToggleButtonView(
            addLabel: LabelConstant.addShortcut,
            removeLabel: LabelConstant.removeShortcut,
            exists: { repository.exists(target: target) },
            add: { repository.add(target: target) },
            remove: { repository.delete(target: target) },
            callback: callback
        )
    }
}
