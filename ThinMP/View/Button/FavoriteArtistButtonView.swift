//
//  FavoriteArtistButtonView.swift
//  ThinMP
//
//  Created by tk on 2021/02/28.
//

import SwiftUI

struct FavoriteArtistButtonView: View {
    let artistId: ArtistId
    var callback: () -> Void = {}
    var register: FavoriteArtistRegisterProtocol = FavoriteArtistRegister()

    var body: some View {
        RegisterToggleButtonView(
            addLabel: LabelConstant.addFavorites,
            removeLabel: LabelConstant.removeFavorites,
            exists: { register.exists(artistId: artistId) },
            add: { register.add(artistId: artistId) },
            remove: { register.delete(artistId: artistId) },
            callback: callback
        )
    }
}
