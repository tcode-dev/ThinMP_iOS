//
//  PlaylistAddRowView.swift
//  ThinMP
//
//  Created by tk on 2021/04/12.
//

import SwiftUI

/// 登録モーダルのプレイリスト 1 行。タップで action を呼ぶ
struct PlaylistAddRowView<Content>: View where Content: View {
    /// すでにこの曲が入っているプレイリストはグレーアウトしてタップ不可にする
    let isRegistered: Bool
    let action: () -> Void
    let content: () -> Content

    var body: some View {
        Button(action: action) {
            HStack {
                content()
                if isRegistered {
                    Text(LocalizedStringKey(LabelConstant.registered))
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .padding(.trailing, StyleConstant.Padding.tiny)
                }
            }
        }
        .disabled(isRegistered)
        .opacity(isRegistered ? 0.4 : 1)
    }
}
