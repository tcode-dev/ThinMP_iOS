//
//  PlaylistAddRowView.swift
//  ThinMP
//
//  Created by tk on 2021/04/12.
//

import SwiftUI

/// 登録モーダルのプレイリスト 1 行。タップで action を呼ぶ
struct PlaylistAddRowView<Content: View>: View {
    private let registeredOpacity = 0.4

    /// すでにこの曲が入っているプレイリストはグレーアウトしてタップ不可にする
    let isRegistered: Bool
    let action: () -> Void
    @ViewBuilder let content: () -> Content

    var body: some View {
        Button(action: action) {
            HStack {
                content()
                if isRegistered {
                    Text(label: LabelConstant.registered)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .padding(.trailing, StyleConstant.Padding.tiny)
                }
            }
        }
        .disabled(isRegistered)
        .opacity(isRegistered ? registeredOpacity : 1)
    }
}
