//
//  SquareImageView.swift
//  ThinMP
//
//  Created by tk on 2020/01/22.
//

import SwiftUI
import MediaPlayer

struct SquareImageView: View {
    var artwork: MPMediaItemArtwork?
    var cgSize: CGSize

    var body: some View {
        Image(uiImage: artwork?.image(at: cgSize) ?? UIImage())
            .renderingMode(.original)
            .resizable()
            .aspectRatio(1, contentMode: .fit)
            .cornerRadius(4)
            .overlay(RoundedRectangle(cornerRadius: 4)
                .stroke(Color("#f2f2f2"), lineWidth: 1))
    }
}
