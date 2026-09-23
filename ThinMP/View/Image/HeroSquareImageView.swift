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
    /// 下端を背景に溶かすグラデーションの高さ。size に対する割合
    private let gradientRate: CGFloat = 0.3

    let size: CGFloat
    let artwork: MPMediaItemArtwork?

    var body: some View {
        ZStack(alignment: .bottom) {
            VStack {
                Image(artwork: artwork, size: CGSize(width: size, height: size), placeholder: "Song")
                    .resizable()
                    .scaledToFit()
            }
            .frame(width: size, height: size)
            HeroGradientView()
                .frame(height: size * gradientRate)
        }
    }
}
