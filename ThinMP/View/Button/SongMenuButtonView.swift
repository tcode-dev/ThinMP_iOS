//
//  SongMenuButtonView.swift
//  ThinMP
//
//  Created by tk on 2021/02/20.
//

import SwiftUI
import MediaPlayer

struct SongMenuButtonView: View {
    var ADD_TEXT: String = "お気に入りに追加"
    var DELETE_TEXT: String = "お気に入りから削除"

    let persistentId: MPMediaEntityPersistentID

    var body: some View {
        Menu {
            createButton()
        } label: {
            MenuImageView()
                .frame(width: 50, height: 50)
        }
    }

    func createButton() -> some View {
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
