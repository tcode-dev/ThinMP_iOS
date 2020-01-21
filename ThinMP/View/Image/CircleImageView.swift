//
//  CircleImageView.swift
//  ThinMP
//
//  Created by tk on 2020/01/22.
//

import SwiftUI
import MediaPlayer

struct CircleImageView: View {
    var artwork: MPMediaItemArtwork?
    var size: CGFloat
    
    var body: some View {
        Image(uiImage: self.artwork?.image(at: CGSize(width: size, height: size)) ?? UIImage())
            .resizable()
            .scaledToFit()
            .clipShape(Circle())
            .overlay(RoundedRectangle(cornerRadius: size / 2)
                .stroke(Color("#f2f2f2"), lineWidth: 1))
            .frame(width: size)
    }
}
