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
        Image(uiImage: artwork?.image(at: CGSize(width: size, height: size)) ?? UIImage(imageLiteralResourceName: "Song"))
            .renderingMode(.original)
            .resizable()
            .scaledToFit()
            .cornerRadius(4)
            .frame(width: abs(size), height: abs(size))
    }
}
