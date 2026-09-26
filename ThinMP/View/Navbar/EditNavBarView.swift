//
//  EditNavBarView.swift
//  ThinMP
//
//  Created by tk on 2021/04/30.
//

import SwiftUI

/// 編集ページ共通のナビゲーションバー。左にキャンセル、右に完了を置く
struct EditNavBarView: View {
    let top: CGFloat
    /// false のあいだは完了を押せない(プレイリスト名が空のときなど)
    let isDoneEnabled: Bool
    let onCancel: () -> Void
    let onDone: () -> Void

    var body: some View {
        HStack {
            Button(.cancel, action: onCancel)
            Spacer()
            Button(.done, action: onDone)
                .disabled(!isDoneEnabled)
        }
        .padding(.horizontal, StyleConstant.Padding.large)
        .frame(height: StyleConstant.Height.row)
        .padding(.top, top)
        .barBackground()
        .zIndex(1)
    }
}
