//
//  ListEmptyHeaderView.swift
//  ThinMP
//
//  Created by tk on 2021/01/25.
//

import SwiftUI

/// 一覧の先頭に置くナビゲーションバー分の空き。自分の位置を親に渡し、ナビゲーションバーの背景表示に使う
struct ListEmptyHeaderView: View {
    @Binding var headerRect: CGRect

    let top: CGFloat

    var body: some View {
        Color.clear
            .frame(height: StyleConstant.Height.row + top)
            .onGeometryChange(for: CGRect.self) { proxy in
                proxy.frame(in: .global)
            } action: { rect in
                headerRect = rect
            }
    }
}
