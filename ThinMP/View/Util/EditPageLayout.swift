//
//  EditPageLayout.swift
//  ThinMP
//
//  Created by tk on 2026/09/22.
//

import SwiftUI

/// 編集ページ共通の骨組み
/// キャンセル / 完了のナビゲーションバーの下に content を編集モードで置く。完了は onDone を呼んでから閉じる
struct EditPageLayout<Content: View>: View {
    @Environment(\.dismiss) private var dismiss

    /// false のあいだは完了を押せない(プレイリスト名が空のときなど)
    var isDoneEnabled = true
    /// ナビゲーションバーのボタン以外をタップしたときに呼ばれる(キーボードを閉じるなど)
    var onNavBarTap: () -> Void = {}
    let onDone: () -> Void
    @ViewBuilder let content: () -> Content

    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                EditNavBarView(top: geometry.safeAreaInsets.top, isDoneEnabled: isDoneEnabled, onCancel: { dismiss() }) {
                    onDone()
                    dismiss()
                }
                .onTapGesture(perform: onNavBarTap)
                content()
            }
            .modifier(PageModifier())
            .environment(\.editMode, .constant(.active))
        }
    }
}
