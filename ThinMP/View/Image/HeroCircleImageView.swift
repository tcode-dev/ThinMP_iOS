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
        let height = isLandscape ? height + top + bottom : width

        Group {
            VStack {
                Image(uiImage: artwork?.image(at: CGSize(width: self.width, height: height)) ?? UIImage())
                    .resizable()
                    .scaledToFill()
                    .frame(width: self.width, height: height)
                    .clipped()
                    .blur(radius: 10.0)
            }
            .frame(width: self.width, height: height)
            LinearGradient(gradient: Gradient(colors: [Color(Color.RGBColorSpace.sRGB, red: 1, green: 1, blue: 1, opacity: 0), Color(UIColor.systemBackground)]), startPoint: .top, endPoint: .bottom)
                .frame(height: 355)
                .offset(y: 25)
            CircleImageView(artwork: artwork, size: height / 3)
                .offset(y: -(height / 3))
        }
    }
}
