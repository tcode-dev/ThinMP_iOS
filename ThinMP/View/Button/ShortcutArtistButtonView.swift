//
//  ShortcutArtistButtonView.swift
//  ThinMP
//
//  Created by tk on 2021/05/08.
//

import SwiftUI
import MediaPlayer

struct ShortcutArtistButtonView: View {
    private let ADD_TEXT: String = "ショートカットに追加"
    private let DELETE_TEXT: String = "ショートカットから削除"

    let persistentId: MPMediaEntityPersistentID

    var body: some View {
        let register = ShortcutRegister()

        if (!register.existsArtist(persistentId: persistentId)) {
            // add
            return Button(action: {
                register.addArtist(persistentId: persistentId)
            }) {
                Text(ADD_TEXT)
            }
        } else {
            // delete
            return Button(action: {
                register.deleteArtist(persistentId: persistentId)
            }) {
                Text(DELETE_TEXT)
            }
        }
    }
}
