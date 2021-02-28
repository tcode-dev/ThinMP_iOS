//
//  FavoriteArtistButtonView.swift
//  ThinMP
//
//  Created by tk on 2021/02/28.
//

import SwiftUI
import MediaPlayer

struct FavoriteArtistButtonView: View {
    private let ADD_TEXT: String = "お気に入りに追加"
    private let DELETE_TEXT: String = "お気に入りから削除"

    let persistentId: MPMediaEntityPersistentID

    var body: some View {
        let favoriteArtistRegister = FavoriteArtistRegister()

        if (!favoriteArtistRegister.exists(persistentId: persistentId)) {
            // add
            return Button(action: {
                favoriteArtistRegister.add(persistentId: persistentId)
            }) {
                Text(ADD_TEXT)
            }
        } else {
            // delete
            return Button(action: {
                favoriteArtistRegister.delete(persistentId: persistentId)
            }) {
                Text(DELETE_TEXT)
            }
        }
    }
}
