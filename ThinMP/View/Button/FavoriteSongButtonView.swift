//
//  FavoriteSongButtonView.swift
//  ThinMP
//
//  Created by tk on 2021/02/28.
//

import SwiftUI
import MediaPlayer

struct FavoriteSongButtonView: View {
    private let ADD_TEXT: String = "お気に入りに追加"
    private let DELETE_TEXT: String = "お気に入りから削除"

    let persistentId: MPMediaEntityPersistentID

    var body: some View {
        let favoriteSongRegister = FavoriteSongRegister()

        if (!favoriteSongRegister.exists(persistentId: persistentId)) {
            // add
            return Button(action: {
                favoriteSongRegister.add(persistentId: persistentId)
            }) {
                Text(ADD_TEXT)
            }
        } else {
            // delete
            return Button(action: {
                favoriteSongRegister.delete(persistentId: persistentId)
            }) {
                Text(DELETE_TEXT)
            }
        }
    }
}
