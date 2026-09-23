//
//  ListEmptyHeaderView.swift
//  ThinMP
//
//  Created by tk on 2021/01/25.
//

import SwiftUI

/// 一覧の先頭に置くナビゲーションバー分の空き。潜り込んだかを親に渡し、ナビゲーションバーの背景表示に使う
struct ListEmptyHeaderView: View {
    @Binding var isScrolledUnder: Bool

    let top: CGFloat

    var body: some View {
        Color.clear
            .frame(height: StyleConstant.Height.row + top)
            // 高さがセーフエリアの分を含んでいるので、基準は画面の上端
            // 位置そのものではなく判定結果を渡すので、State が変わるのは境目を越えたときだけになる
            .onGeometryChange(for: Bool.self) { proxy in
                proxy.frame(in: .global).minY < 0
            } action: { isScrolledUnder in
                self.isScrolledUnder = isScrolledUnder
            }
    }
}
