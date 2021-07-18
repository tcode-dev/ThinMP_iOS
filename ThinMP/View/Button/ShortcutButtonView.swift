//
//  ShortcutButtonView.swift
//  ThinMP
//
//  Created by tk on 2021/05/08.
//

import MediaPlayer
import SwiftUI

struct ShortcutButtonView: View {
    @State private var displayed: Bool = false
    @State private var exists: Bool = false

    private let itemId: ShortcutItemIdProtocol
    private let type: ShortcutType
    private let callback: () -> Void

    init(itemId: ShortcutItemIdProtocol, type: ShortcutType, callback: @escaping () -> Void = {}) {
        self.itemId = itemId
        self.type = type
        self.callback = callback
    }

    var body: some View {
        if !displayed {
            let register = ShortcutRegister()

            if !register.exists(itemId: itemId, type: type) {
                return Button(action: {
                    let register = ShortcutRegister()

                    register.add(itemId: itemId, type: type)
                    exists = true
                    displayed.toggle()
                    callback()
                }) {
                    Text("AddShortcut")
                }
            } else {
                return Button(action: {
                    let register = ShortcutRegister()

                    register.delete(itemId: itemId, type: type)
                    exists = false
                    displayed.toggle()
                    callback()
                }) {
                    Text("RemoveShortcut")
                }
            }
        } else {
            if !exists {
                return Button(action: {
                    let register = ShortcutRegister()

                    register.add(itemId: itemId, type: type)
                    exists.toggle()
                    callback()
                }) {
                    Text("AddShortcut")
                }
            } else {
                return Button(action: {
                    let register = ShortcutRegister()

                    register.delete(itemId: itemId, type: type)
                    exists.toggle()
                    callback()
                }) {
                    Text("RemoveShortcut")
                }
            }
        }
    }
}
