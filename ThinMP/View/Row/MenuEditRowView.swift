//
//  MenuEditRowView.swift
//  ThinMP
//
//  Created by tk on 2021/06/12.
//

import SwiftUI

/// メイン編集ページの行。タップで表示 / 非表示を切り替える
struct MenuEditRowView: View {
    let text: String
    @Binding var visibility: Bool

    var body: some View {
        HStack(alignment: .center) {
            Image(visibility ? "CheckboxOn" : "CheckboxOff").renderingMode(.original)
            MenuRowView(text: text)
            Spacer()
        }
        .padding(.leading, StyleConstant.Padding.large)
        .onTapGesture {
            visibility.toggle()
        }
    }
}
