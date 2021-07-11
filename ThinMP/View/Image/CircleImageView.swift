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
        Image(uiImage: self.artwork?.image(at: CGSize(width: size, height: size)) ?? UIImage(imageLiteralResourceName: "Artist"))
            .resizable()
            .scaledToFill()
            .clipShape(Circle())
            .frame(width: size, height: size)
    }
}
