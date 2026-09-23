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
        Image(artwork: artwork, size: CGSize(width: size, height: size), placeholder: .song)
            .renderingMode(.original)
            .resizable()
            .scaledToFit()
            .clipShape(.rect(cornerRadius: StyleConstant.cornerRadius))
            .frame(width: size, height: size)
    }
}
