//
//  ShortcutButtonView.swift
//  ThinMP
//
//  Created by tk on 2021/05/08.
//

import SwiftUI
import MediaPlayer

struct ShortcutButtonView: View {
    private let ADD_TEXT: String = "ショートカットに追加"
    private let DELETE_TEXT: String = "ショートカットから削除"

    @State private var displayed: Bool = false
    @State private var exists: Bool = false

    let itemId: ShortcutItemIdProtocol
    let type: ShortcutType

    var body: some View {
        if (!displayed) {
            let register = ShortcutRegister()

            if (!register.exists(itemId: itemId, type: type)) {
                return Button(action: {
                    let register = ShortcutRegister()

                    register.add(itemId: itemId, type: type)
                    exists = true
                    displayed.toggle()
                }) {
                    Text(ADD_TEXT)
                }
            } else {
                return Button(action: {
                    let register = ShortcutRegister()

                    register.delete(itemId: itemId, type: type)
                    exists = false
                    displayed.toggle()
                }) {
                    Text(DELETE_TEXT)
                }
            }
        } else {
            if (!exists) {
                return Button(action: {
                    let register = ShortcutRegister()

                    register.add(itemId: itemId, type: type)
                    exists.toggle()
                }) {
                    Text(ADD_TEXT)
                }
            } else {
                return Button(action: {
                    let register = ShortcutRegister()

                    register.delete(itemId: itemId, type: type)
                    exists.toggle()
                }) {
                    Text(DELETE_TEXT)
                }
            }
        }
    }
}
