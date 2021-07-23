//
//  FavoriteArtistButtonView.swift
//  ThinMP
//
//  Created by tk on 2021/02/28.
//

import MediaPlayer
import SwiftUI

struct FavoriteArtistButtonView: View {
    @State private var initialDisplay: Bool = true
    @State private var exists: Bool = false

    private let artistId: ArtistId
    private let callback: () -> Void

    init(artistId: ArtistId, callback: @escaping () -> Void = {}) {
        self.artistId = artistId
        self.callback = callback
    }

    var body: some View {
        Group {
            if initialDisplay {
                let register = FavoriteArtistRegister()

                if !register.exists(artistId: artistId) {
                    createAddButton()
                } else {
                    createRemoveButton()
                }
            } else {
                if !exists {
                    createAddButton()
                } else {
                    createRemoveButton()
                }
            }
        }
    }

    private func createAddButton() -> some View {
        return Button(action: {
            let register = FavoriteArtistRegister()

            register.add(artistId: artistId)
            exists = true
            initialDisplay = false
            callback()
        }) {
            Text("AddFavorites")
        }
    }

    private func createRemoveButton() -> some View {
        Button(action: {
            let register = FavoriteArtistRegister()

            register.delete(artistId: artistId)
            exists = false
            initialDisplay = false
            callback()
        }) {
            Text("RemoveFavorites")
        }
    }
}
