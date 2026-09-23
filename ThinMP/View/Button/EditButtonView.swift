//
//  EditButtonView.swift
//  ThinMP
//
//  Created by tk on 2021/02/28.
//

import SwiftUI

/// 編集ページへの遷移だけを持つメニューボタン
struct EditButtonView<Content: View>: View {
    @ViewBuilder let content: () -> Content

    var body: some View {
        MenuButtonView {
            NavigationLink(destination: content()) {
                MenuRowView(key: LabelConstant.edit)
            }
        }
    }
}
