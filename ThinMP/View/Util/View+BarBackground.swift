//
//  View+BarBackground.swift
//  ThinMP
//
//  Created by tk on 2026/09/23.
//

import SwiftUI

extension View {
    /// ナビゲーションバーとミニプレイヤーの背景。画面の内容と見分けられるように枠線を引く
    func barBackground() -> some View {
        return background(Color(.secondarySystemBackground))
            .border(Color(.systemGray5), width: 1)
    }
}
