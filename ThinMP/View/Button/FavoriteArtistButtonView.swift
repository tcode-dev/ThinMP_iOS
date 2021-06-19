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

    @State private var displayed: Bool = false
    @State private var exists: Bool = false

    let persistentId: MPMediaEntityPersistentID

    var body: some View {
        if (!displayed) {
            let register = FavoriteArtistRegister()

            if (!register.exists(persistentId: persistentId)) {
                return Button(action: {
                    let register = FavoriteSongRegister()

                    register.add(persistentId: persistentId)
                    exists = true
                    displayed.toggle()
                }) {
                    Text(ADD_TEXT)
                }
            } else {
                return Button(action: {
                    let register = FavoriteArtistRegister()

                    register.delete(persistentId: persistentId)
                    exists = false
                    displayed.toggle()
                }) {
                    Text(DELETE_TEXT)
                }
            }
        } else {
            if (!exists) {
                return Button(action: {
                    let register = FavoriteArtistRegister()

                    register.add(persistentId: persistentId)
                    exists.toggle()
                }) {
                    Text(ADD_TEXT)
                }
            } else {
                return Button(action: {
                    let register = FavoriteArtistRegister()

                    register.delete(persistentId: persistentId)
                    exists.toggle()
                }) {
                    Text(DELETE_TEXT)
                }
            }
        }
    }
}
