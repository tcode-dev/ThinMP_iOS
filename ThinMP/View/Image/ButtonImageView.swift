//
//  ButtonImageView.swift
//  ThinMP
//
//  Created by tk on 2026/09/22.
//

import SwiftUI

/// プレイヤーのボタンに使う size 四方のアセット画像。dimmed はリピート / シャッフル / お気に入りがオフのときの表示
struct ButtonImageView: View {
    let name: String
    let size: CGFloat
    var dimmed: Bool = false

    var body: some View {
        Image(name)
            .renderingMode(.original)
            .resizable()
            .frame(width: size, height: size)
            .opacity(dimmed ? 0.5 : 1)
    }
}
