//
//  HeroCircleImageView.swift
//  ThinMP
//
//  Created by tk on 2021/07/22.
//

import MediaPlayer
import SwiftUI

struct HeroCircleImageView: View {
    let width: CGFloat
    let height: CGFloat
    let top: CGFloat
    let bottom: CGFloat
    let artwork: MPMediaItemArtwork?
    let isLandscape = UIDevice.current.orientation.isLandscape

    var body: some View {
        let size = isLandscape ? height + top + bottom : width

        ZStack(alignment: .bottom) {
            VStack {
                Image(uiImage: artwork?.image(at: CGSize(width: self.width, height: size)) ?? UIImage())
                    .resizable()
                    .scaledToFill()
                    .frame(width: self.width, height: size)
                    .clipped()
                    .blur(radius: 10.0)
            }
            .frame(width: self.width, height: size)
            LinearGradient(gradient: Gradient(colors: [Color(Color.RGBColorSpace.sRGB, red: 1, green: 1, blue: 1, opacity: 0), Color(UIColor.systemBackground)]), startPoint: .top, endPoint: .bottom)
                .frame(height: size / 3)
                .offset(y: 20)
            CircleImageView(artwork: artwork, size: size / 3)
                .offset(y: -(size / 3))
        }
    }
}
