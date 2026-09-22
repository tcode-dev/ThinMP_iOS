//
//  FavoriteSongButtonView.swift
//  ThinMP
//
//  Created by tk on 2021/02/28.
//

import SwiftUI

struct FavoriteSongButtonView: View {
    private let register = FavoriteSongRegister()

    let songId: SongId
    var callback: () -> Void = {}

    var body: some View {
        RegisterToggleButtonView(
            addLabel: LabelConstant.addFavorites,
            removeLabel: LabelConstant.removeFavorites,
            exists: { register.exists(songId: songId) },
            add: { register.add(songId: songId) },
            remove: { register.delete(songId: songId) },
            callback: callback
        )
    }
}
