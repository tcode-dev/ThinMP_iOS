//
//  FavoriteArtistsNavBarView.swift
//  ThinMP
//
//  Created by tk on 2021/01/10.
//

import SwiftUI

struct FavoriteArtistsNavBarView: View {
    private let TITLE: String = "Favorite Artists"

    let top: CGFloat
    @Binding var rect: CGRect
    
    var body: some View {
        ListNavBarView(primaryText: TITLE, top: top, rect: $rect) {
            FavoriteArtistsMenuButtonView()
        }
    }
}
