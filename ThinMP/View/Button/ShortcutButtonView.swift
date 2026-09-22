//
//  ShortcutButtonView.swift
//  ThinMP
//
//  Created by tk on 2021/05/08.
//

import SwiftUI

struct ShortcutButtonView: View {
    private let register = ShortcutRegister()
    private let itemId: ItemId
    private let type: ShortcutType
    private let callback: () -> Void

    /// itemId はアーティスト / アルバム / プレイリストの id 文字列(各 Model の `id`)
    init(itemId: String, type: ShortcutType, callback: @escaping () -> Void = {}) {
        self.itemId = ItemId(id: itemId)
        self.type = type
        self.callback = callback
    }

    var body: some View {
        RegisterToggleButtonView(
            addLabel: LabelConstant.addShortcut,
            removeLabel: LabelConstant.removeShortcut,
            exists: { register.exists(itemId: itemId, type: type) },
            add: { register.add(itemId: itemId, type: type) },
            remove: { register.delete(itemId: itemId, type: type) },
            callback: callback
        )
    }
}
