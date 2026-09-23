//
//  View+OnFirstAppear.swift
//  ThinMP
//
//  Created by tk on 2026/09/23.
//

import SwiftUI

extension View {
    /// 最初に表示されたときだけ action を呼ぶ
    /// onAppear や task は NavigationStack で詳細から戻ってくるたびに呼ばれ直すので、
    /// 戻ってきても内容が変わらないページ(ライブラリだけを出すページ)の読み込みに使う
    func onFirstAppear(perform action: @escaping () -> Void) -> some View {
        return modifier(FirstAppearModifier(action: action))
    }
}

private struct FirstAppearModifier: ViewModifier {
    @State private var hasAppeared = false

    let action: () -> Void

    func body(content: Content) -> some View {
        content.onAppear {
            if hasAppeared {
                return
            }

            hasAppeared = true
            action()
        }
    }
}
