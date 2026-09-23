//
//  HeroCircleImageView.swift
//  ThinMP
//
//  Created by tk on 2021/07/22.
//

import MediaPlayer
import SwiftUI

/// アーティスト詳細のヒーロー画像。width × size にぼかしたアートワークを敷き、その上に丸いアートワークを置く
struct HeroCircleImageView: View {
    /// 丸いアートワークの 1 辺はヒーローの高さの 1 / circleDivisor
    private let circleDivisor: CGFloat = 3
    /// グラデーションを下にずらして、ぼかしたアートワークの下端に被せる
    private let gradientOffset: CGFloat = 20

    let width: CGFloat
    let size: CGFloat
    let artwork: MPMediaItemArtwork?

    var body: some View {
        let circleSize = size / circleDivisor

        ZStack(alignment: .bottom) {
            VStack {
                Image(artwork: artwork, size: CGSize(width: width, height: size))
                    .resizable()
                    .scaledToFill()
                    .frame(width: width, height: size)
                    .clipped()
                    .blur(radius: StyleConstant.artworkBlurRadius)
            }
            .frame(width: width, height: size)
            HeroGradientView()
                .frame(height: circleSize)
                .offset(y: gradientOffset)
            CircleImageView(artwork: artwork, size: circleSize)
                .offset(y: -circleSize)
        }
    }
}
