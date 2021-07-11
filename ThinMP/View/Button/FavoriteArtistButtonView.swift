//
//  FavoriteArtistButtonView.swift
//  ThinMP
//
//  Created by tk on 2021/02/28.
//

import SwiftUI
import MediaPlayer

struct FavoriteArtistButtonView: View {
    @State private var displayed: Bool = false
    @State private var exists: Bool = false

    let artistId: ArtistId

    var body: some View {
        if !displayed {
            let register = FavoriteArtistRegister()

            if !register.exists(artistId: artistId) {
                return Button(action: {
                    let register = FavoriteArtistRegister()

                    register.add(artistId: artistId)
                    exists = true
                    displayed.toggle()
                }) {
                    Text("AddFavorites")
                }
            } else {
                return Button(action: {
                    let register = FavoriteArtistRegister()

                    register.delete(artistId: artistId)
                    exists = false
                    displayed.toggle()
                }) {
                    Text("RemoveFavorites")
                }
            }
        } else {
            if !exists {
                return Button(action: {
                    let register = FavoriteArtistRegister()

                    register.add(artistId: artistId)
                    exists.toggle()
                }) {
                    Text("AddFavorites")
                }
            } else {
                return Button(action: {
                    let register = FavoriteArtistRegister()

                    register.delete(artistId: artistId)
                    exists.toggle()
                }) {
                    Text("RemoveFavorites")
                }
            }
        }
    }
}
