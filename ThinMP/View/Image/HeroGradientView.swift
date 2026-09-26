//
//  HeroGradientView.swift
//  ThinMP
//
//  Created by tk on 2026/09/22.
//

import SwiftUI

/// ヒーロー画像の下端を背景色に溶かすグラデーション
/// 透明側も背景色にしておかないと、ダークモードで中間が白く霞む
struct HeroGradientView: View {
    var body: some View {
        LinearGradient(
            colors: [Color(.systemBackground).opacity(0), Color(.systemBackground)],
            startPoint: .top,
            endPoint: .bottom
        )
    }
}
