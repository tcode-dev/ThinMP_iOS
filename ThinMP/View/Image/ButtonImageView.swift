//
//  ButtonImageView.swift
//  ThinMP
//
//  Created by tk on 2026/09/22.
//

import SwiftUI

/// プレイヤーのボタンに使う size 四方のアセット画像。dimmed はリピート / シャッフル / お気に入りがオフのときの表示
struct ButtonImageView: View {
    private let dimmedOpacity = 0.5

    let image: ImageResource
    let size: CGFloat
    var dimmed: Bool = false

    var body: some View {
        Image(image)
            .renderingMode(.original)
            .resizable()
            .frame(width: size, height: size)
            .opacity(dimmed ? dimmedOpacity : 1)
    }
}
