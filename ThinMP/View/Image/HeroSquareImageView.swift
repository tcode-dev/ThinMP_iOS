//
//  HeroSquareImageView.swift
//  ThinMP
//
//  Created by tk on 2021/07/22.
//

import MediaPlayer
import SwiftUI

struct HeroSquareImageView: View {
    let width: CGFloat
    let height: CGFloat
    let top: CGFloat
    let bottom: CGFloat
    let artwork: MPMediaItemArtwork?
    let isLandscape = UIDevice.current.orientation.isLandscape

    var body: some View {
        let size = isLandscape ? height + top + bottom : width

        Group {
            VStack {
                Image(uiImage: artwork?.image(at: CGSize(width: size, height: size)) ?? UIImage(imageLiteralResourceName: "Song"))
                    .resizable()
                    .scaledToFit()
            }
            .frame(width: size, height: size)
            LinearGradient(gradient: Gradient(colors: [Color(Color.RGBColorSpace.sRGB, red: 1, green: 1, blue: 1, opacity: 0), Color(UIColor.systemBackground)]), startPoint: .top, endPoint: .bottom)
                .frame(height: 200)
        }
    }
}
