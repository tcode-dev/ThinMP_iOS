//
//  FavoriteSongButtonView.swift
//  ThinMP
//
//  Created by tk on 2021/02/28.
//

import SwiftUI

struct FavoriteSongButtonView: View {
    let songId: SongId
    var callback: () -> Void = {}
    var service: FavoriteSongsServiceProtocol = FavoriteSongsService()

    var body: some View {
        RegisterToggleButtonView(
            addLabel: LabelConstant.addFavorites,
            removeLabel: LabelConstant.removeFavorites,
            exists: { service.exists(songId: songId) },
            add: { service.add(songId: songId) },
            remove: { service.delete(songId: songId) },
            callback: callback
        )
    }
}
