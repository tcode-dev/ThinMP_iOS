//
//  HeroSquareImageView.swift
//  ThinMP
//
//  Created by tk on 2021/07/22.
//

import MediaPlayer
import SwiftUI

/// アルバム / プレイリスト詳細のヒーロー画像。size 四方のアートワークの下端を背景に溶かす
struct HeroSquareImageView: View {
    let size: CGFloat
    let artwork: MPMediaItemArtwork?

    var body: some View {
        ZStack(alignment: .bottom) {
            VStack {
                Image(uiImage: artwork?.image(at: CGSize(width: size, height: size)) ?? UIImage(imageLiteralResourceName: "Song"))
                    .resizable()
                    .scaledToFit()
            }
            .frame(width: size, height: size)
            HeroGradientView()
                .frame(height: size * 0.3)
        }
    }
}
