//
//  HeroGradientView.swift
//  ThinMP
//
//  Created by tk on 2026/09/22.
//

import SwiftUI

/// ヒーロー画像の下端を背景色に溶かすグラデーション
struct HeroGradientView: View {
    var body: some View {
        LinearGradient(
            gradient: Gradient(colors: [Color(Color.RGBColorSpace.sRGB, red: 1, green: 1, blue: 1, opacity: 0), Color(UIColor.systemBackground)]),
            startPoint: .top,
            endPoint: .bottom
        )
    }
}
