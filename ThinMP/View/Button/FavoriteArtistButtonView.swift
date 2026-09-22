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
    var repository: FavoriteArtistRepositoryProtocol = FavoriteArtistRepository()

    var body: some View {
        RegisterToggleButtonView(
            addLabel: LabelConstant.addFavorites,
            removeLabel: LabelConstant.removeFavorites,
            exists: { repository.exists(artistId: artistId) },
            add: { repository.add(artistId: artistId) },
            remove: { repository.delete(artistId: artistId) },
            callback: callback
        )
    }
}
