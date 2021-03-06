//
//  FavoriteSongsNavBarView.swift
//  ThinMP
//
//  Created by tk on 2021/02/23.
//

import SwiftUI

struct FavoriteSongsNavBarView: View {
    private let TITLE: String = "Favorite Songs"

    let top: CGFloat
    @Binding var rect: CGRect

    var body: some View {
        ListNavBarView(primaryText: TITLE, top: top, rect: $rect) {
            FavoriteArtistsMenuButtonView()
        }
    }
}
