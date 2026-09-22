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
    let width: CGFloat
    let size: CGFloat
    let artwork: MPMediaItemArtwork?

    var body: some View {
        ZStack(alignment: .bottom) {
            VStack {
                Image(uiImage: artwork?.image(at: CGSize(width: width, height: size)) ?? UIImage())
                    .resizable()
                    .scaledToFill()
                    .frame(width: width, height: size)
                    .clipped()
                    .blur(radius: 10.0)
            }
            .frame(width: width, height: size)
            HeroGradientView()
                .frame(height: size / 3)
                .offset(y: 20)
            CircleImageView(artwork: artwork, size: size / 3)
                .offset(y: -(size / 3))
        }
    }
}
