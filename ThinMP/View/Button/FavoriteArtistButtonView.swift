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
    var service: FavoriteArtistsServiceProtocol = FavoriteArtistsService()

    var body: some View {
        RegisterToggleButtonView(
            addLabel: LabelConstant.addFavorites,
            removeLabel: LabelConstant.removeFavorites,
            exists: { service.exists(artistId: artistId) },
            add: { service.add(artistId: artistId) },
            remove: { service.delete(artistId: artistId) },
            callback: callback
        )
    }
}
