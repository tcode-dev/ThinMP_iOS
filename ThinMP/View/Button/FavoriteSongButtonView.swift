//
//  FavoriteSongButtonView.swift
//  ThinMP
//
//  Created by tk on 2021/02/28.
//

import SwiftUI

struct FavoriteSongButtonView: View {
    let songId: SongId
    /// 登録 / 解除のあとに呼ばれる(一覧の再読み込みなど)
    var onToggle: () -> Void = {}
    private let repository: FavoriteSongRepositoryProtocol = FavoriteSongRepository()

    var body: some View {
        RegisterToggleButtonView(
            addLabel: .addFavorites,
            removeLabel: .removeFavorites,
            exists: { repository.exists(songId: songId) },
            toggle: { repository.toggle(songId: songId) },
            onToggle: onToggle
        )
    }
}
