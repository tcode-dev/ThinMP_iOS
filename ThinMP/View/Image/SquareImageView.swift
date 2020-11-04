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
    var size: CGFloat
    
    var body: some View {
        Image(uiImage: artwork?.image(at: CGSize(width: size, height: size)) ?? UIImage())
            .renderingMode(.original)
            .resizable()
            .scaledToFit()
            .cornerRadius(4)
            .overlay(
                RoundedRectangle(cornerRadius: 4)
                    .stroke(Color("#f2f2f2"), lineWidth: 1)
            )
            .frame(width: abs(size), height: abs(size))
    }
}
