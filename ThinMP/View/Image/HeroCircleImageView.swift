//
//  HeroCircleImageView.swift
//  ThinMP
//
//  Created by tk on 2021/07/22.
//

import MediaPlayer
import SwiftUI

struct HeroCircleImageView: View {
    let side: CGFloat
    let artwork: MPMediaItemArtwork?

    var body: some View {
        Group {
            VStack {
                Image(uiImage: artwork?.image(at: CGSize(width: side, height: side)) ?? UIImage())
                    .resizable()
                    .scaledToFit()
                    .blur(radius: 10.0)
            }
            .frame(width: side, height: side)
            LinearGradient(gradient: Gradient(colors: [Color(Color.RGBColorSpace.sRGB, red: 1, green: 1, blue: 1, opacity: 0), Color(UIColor.systemBackground)]), startPoint: .top, endPoint: .bottom)
                .frame(height: 355)
                .offset(y: 25)
            CircleImageView(artwork: artwork, size: side / 3)
                .offset(y: -(side / 3))
        }
    }
}
