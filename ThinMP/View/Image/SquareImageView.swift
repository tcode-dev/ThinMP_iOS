//
//  SquareImageView.swift
//  ThinMP
//
//  Created by tk on 2020/01/22.
//

import MediaPlayer
import SwiftUI

struct SquareImageView: View {
    let artwork: MPMediaItemArtwork?
    let size: CGFloat

    var body: some View {
        Image(artwork: artwork, size: CGSize(width: size, height: size), placeholder: "Song")
            .renderingMode(.original)
            .resizable()
            .scaledToFit()
            .cornerRadius(StyleConstant.cornerRadius)
            .frame(width: max(0, size), height: max(0, size))
    }
}
