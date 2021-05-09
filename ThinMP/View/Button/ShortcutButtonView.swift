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

    let itemId: ShortcutItemIdProtocol
    let type: ShortcutType

    var body: some View {
        let register = ShortcutRegister()

        if (!register.exists(itemId: itemId, type: type)) {
            // add
            return Button(action: {
                register.add(itemId: itemId, type: type)
            }) {
                Text(ADD_TEXT)
            }
        } else {
            // delete
            return Button(action: {
                register.delete(itemId: itemId, type: type)
            }) {
                Text(DELETE_TEXT)
            }
        }
    }
}
