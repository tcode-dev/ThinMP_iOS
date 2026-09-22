//
//  FavoriteArtistButtonView.swift
//  ThinMP
//
//  Created by tk on 2021/02/28.
//

import SwiftUI

struct FavoriteArtistButtonView: View {
    let artistId: ArtistId
    /// 登録 / 解除のあとに呼ばれる(一覧の再読み込みなど)
    var onToggle: () -> Void = {}
    var repository: FavoriteArtistRepositoryProtocol = FavoriteArtistRepository()

    var body: some View {
        RegisterToggleButtonView(
            addLabel: LabelConstant.addFavorites,
            removeLabel: LabelConstant.removeFavorites,
            exists: { repository.exists(artistId: artistId) },
            toggle: { repository.toggle(artistId: artistId) },
            onToggle: onToggle
        )
    }
}
