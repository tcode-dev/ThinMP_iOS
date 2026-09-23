//
//  EditLinkView.swift
//  ThinMP
//
//  Created by tk on 2026/09/23.
//

import SwiftUI

/// メニューに置く、編集ページへ遷移する行
/// 編集だけのメニューは EditButtonView、他の項目と並べるメニューはこれを直接置く
struct EditLinkView<Destination: View>: View {
    @ViewBuilder let destination: () -> Destination

    var body: some View {
        NavigationLink(destination: destination()) {
            MenuRowView(key: LabelConstant.edit)
        }
    }
}
