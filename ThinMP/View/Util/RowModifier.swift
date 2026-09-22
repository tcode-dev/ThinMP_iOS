//
//  RowModifier.swift
//  ThinMP
//
//  Created by tk on 2026/09/23.
//

import SwiftUI

/// 一覧の行共通の大きさ。行の高さを揃え、左右に少しだけ余白を置く
struct RowModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .frame(height: StyleConstant.Height.row)
            .padding(.horizontal, StyleConstant.Padding.tiny)
    }
}
