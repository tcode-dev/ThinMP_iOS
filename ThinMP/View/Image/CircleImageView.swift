//
//  CircleImageView.swift
//  ThinMP
//
//  Created by tk on 2020/01/22.
//

import MediaPlayer
import SwiftUI

struct CircleImageView: View {
    let artwork: MPMediaItemArtwork?
    let size: CGFloat

    var body: some View {
        Image(artwork: artwork, size: CGSize(width: size, height: size), placeholder: "Artist")
            .resizable()
            .scaledToFill()
            .clipShape(Circle())
            .frame(width: size, height: size)
    }
}
