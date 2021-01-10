//
//  FavoriteArtistsHeader.swift
//  ThinMP
//
//  Created by tk on 2021/01/10.
//

import SwiftUI
import MediaPlayer

struct FavoriteArtistsHeader: View {
    var primaryText: String = "FavoriteArtists"

    var body: some View {
        HStack {
            BackButtonView()
            Spacer()
            PrimaryTextView(self.primaryText)
            Spacer()
            FavoriteArtistsMenuButton()
        }
        .frame(height: 50, alignment: .bottom)
    }
}
