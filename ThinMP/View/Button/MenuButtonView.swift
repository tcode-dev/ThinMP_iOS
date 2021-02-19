//
//  MenuButtonView.swift
//  ThinMP
//
//  Created by tk on 2020/01/24.
//

import SwiftUI
import MediaPlayer

struct MenuButtonView: View {
    var persistentId: MPMediaEntityPersistentID
    var primaryText: String?
    var ADD_TEXT: String = "お気に入りアーティストに追加"
    var DELETE_TEXT: String = "お気に入りアーティストから削除"
    @State var isOpen: Bool = false

    var body: some View {
        Menu {
            favoriteArtistButton()
        } label: {
            MenuImageView()
                .frame(width: 50, height: 50)
        }
    }

    func favoriteArtistButton() -> some View {
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
