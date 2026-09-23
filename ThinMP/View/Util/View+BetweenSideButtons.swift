//
//  View+BetweenSideButtons.swift
//  ThinMP
//
//  Created by tk on 2026/09/23.
//

import SwiftUI

extension View {
    /// 左右の端に StyleConstant.button 幅のボタンを置く行で、ボタンの間の幅いっぱいに中央寄せで置く
    /// ヒーローのタイトルと説明、ナビゲーションバーのタイトルで共有する
    /// width がボタン 2 つ分より狭いと幅は 0(負の frame を渡さない)
    func betweenSideButtons(width: CGFloat, height: CGFloat) -> some View {
        return frame(width: max(0, width - StyleConstant.button * 2), height: height)
            .padding(.horizontal, StyleConstant.button)
    }
}
