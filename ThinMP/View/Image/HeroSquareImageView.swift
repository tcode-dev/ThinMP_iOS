//
//  HeroSquareImageView.swift
//  ThinMP
//
//  Created by tk on 2021/07/22.
//

import MediaPlayer
import SwiftUI

struct HeroSquareImageView: View {
    let side: CGFloat
    let artwork: MPMediaItemArtwork?

    var body: some View {
        Group {
            Image(uiImage: artwork?.image(at: CGSize(width: side, height: side)) ?? UIImage(imageLiteralResourceName: "Song"))
                .resizable()
                .scaledToFit()
            LinearGradient(gradient: Gradient(colors: [Color(Color.RGBColorSpace.sRGB, red: 1, green: 1, blue: 1, opacity: 0), Color(UIColor.systemBackground)]), startPoint: .top, endPoint: .bottom)
                .frame(height: 200)
        }
    }
}
