//
//  MenuEditRowView.swift
//  ThinMP
//
//  Created by tk on 2021/06/12.
//

import SwiftUI

/// メイン編集ページの行。タップで表示 / 非表示を切り替える
struct MenuEditRowView: View {
    let key: String
    @Binding var isVisible: Bool

    var body: some View {
        HStack(alignment: .center) {
            Image(isVisible ? .checkboxOn : .checkboxOff).renderingMode(.original)
            MenuRowView(key: key)
            Spacer()
        }
        .padding(.leading, StyleConstant.Padding.large)
        // Spacer と余白はそのままではタップを受けないので、行全体を当たり判定にする
        .contentShape(Rectangle())
        .onTapGesture {
            isVisible.toggle()
        }
        // onTapGesture だけではボタンとして読まれないので、VoiceOver には 1 つのボタンとして見せる
        // チェックボックスの画像名は読ませず、表示中かどうかは「選択中」で伝える
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(Text(label: key))
        .accessibilityAddTraits(isVisible ? [.isButton, .isSelected] : .isButton)
        .accessibilityAction {
            isVisible.toggle()
        }
    }
}
