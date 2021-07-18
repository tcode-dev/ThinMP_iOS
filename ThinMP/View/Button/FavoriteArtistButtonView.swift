//
//  FavoriteArtistButtonView.swift
//  ThinMP
//
//  Created by tk on 2021/02/28.
//

import MediaPlayer
import SwiftUI

struct FavoriteArtistButtonView: View {
    @State private var displayed: Bool = false
    @State private var exists: Bool = false

    private let artistId: ArtistId
    private let callback: () -> Void

    init(artistId: ArtistId, callback: @escaping () -> Void = {}) {
        self.artistId = artistId
        self.callback = callback
    }

    var body: some View {
        if !displayed {
            let register = FavoriteArtistRegister()

            if !register.exists(artistId: artistId) {
                return Button(action: {
                    let register = FavoriteArtistRegister()

                    register.add(artistId: artistId)
                    exists = true
                    displayed.toggle()
                    callback()
                }) {
                    Text("AddFavorites")
                }
            } else {
                return Button(action: {
                    let register = FavoriteArtistRegister()

                    register.delete(artistId: artistId)
                    exists = false
                    displayed.toggle()
                    callback()
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
                    callback()
                }) {
                    Text("AddFavorites")
                }
            } else {
                return Button(action: {
                    let register = FavoriteArtistRegister()

                    register.delete(artistId: artistId)
                    exists.toggle()
                    callback()
                }) {
                    Text("RemoveFavorites")
                }
            }
        }
    }
}
