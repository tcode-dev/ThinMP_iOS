//
//  PageModifier.swift
//  ThinMP
//
//  Created by tk on 2026/09/22.
//

import SwiftUI

/// 全ページ共通の設定。システムのナビゲーションバーを隠して自前のナビゲーションバーを使い、セーフエリアまで描画する
struct PageModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .toolbar(.hidden, for: .navigationBar)
            .navigationTitle("")
            .ignoresSafeArea(.container)
    }
}
