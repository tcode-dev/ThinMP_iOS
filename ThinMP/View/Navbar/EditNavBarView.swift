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
    var isDoneEnabled: Bool = true
    let onCancel: () -> Void
    let onDone: () -> Void

    var body: some View {
        HStack {
            Button(action: onCancel) {
                Text(label: LabelConstant.cancel)
            }
            Spacer()
            Button(action: onDone) {
                Text(label: LabelConstant.done)
            }
            .disabled(!isDoneEnabled)
        }
        .padding(.horizontal, StyleConstant.Padding.large)
        .frame(height: StyleConstant.Height.row)
        .padding(.top, top)
        .background(Color(UIColor.secondarySystemBackground))
        .border(Color(UIColor.systemGray5), width: 1)
        .zIndex(1)
    }
}
