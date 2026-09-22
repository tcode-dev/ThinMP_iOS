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
    var repository: FavoriteSongRepositoryProtocol = FavoriteSongRepository()

    var body: some View {
        RegisterToggleButtonView(
            addLabel: LabelConstant.addFavorites,
            removeLabel: LabelConstant.removeFavorites,
            exists: { repository.exists(songId: songId) },
            add: { repository.add(songId: songId) },
            remove: { repository.delete(songId: songId) },
            callback: callback
        )
    }
}
