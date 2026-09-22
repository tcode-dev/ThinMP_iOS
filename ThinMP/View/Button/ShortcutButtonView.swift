//
//  ShortcutButtonView.swift
//  ThinMP
//
//  Created by tk on 2021/05/08.
//

import SwiftUI

struct ShortcutButtonView: View {
    @State private var initialDisplay: Bool = true
    @State private var exists: Bool = false

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
        Group {
            if initialDisplay {
                let register = ShortcutRegister()

                if !register.exists(itemId: itemId, type: type) {
                    createAddButton()
                } else {
                    createRemoveButton()
                }
            } else {
                if !exists {
                    createAddButton()
                } else {
                    createRemoveButton()
                }
            }
        }
    }

    private func createAddButton() -> some View {
        return Button(action: {
            let register = ShortcutRegister()

            register.add(itemId: itemId, type: type)
            exists = true
            initialDisplay = false
            callback()
        }) {
            Text(LocalizedStringKey(LabelConstant.addShortcut))
        }
    }

    private func createRemoveButton() -> some View {
        Button(action: {
            let register = ShortcutRegister()

            register.delete(itemId: itemId, type: type)
            exists = false
            initialDisplay = false
            callback()
        }) {
            Text(LocalizedStringKey(LabelConstant.removeShortcut))
        }
    }
}
