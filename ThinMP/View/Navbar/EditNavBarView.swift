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
    let onCancel: () -> Void
    let onDone: () -> Void

    var body: some View {
        HStack {
            Button(action: onCancel) {
                Text(LocalizedStringKey(LabelConstant.cancel))
            }
            Spacer()
            Button(action: onDone) {
                Text(LocalizedStringKey(LabelConstant.done))
            }
        }
        .padding(.horizontal, StyleConstant.Padding.large)
        .frame(height: StyleConstant.Height.row)
        .padding(EdgeInsets(
            top: top,
            leading: 0,
            bottom: 0,
            trailing: 0
        ))
        .frame(height: StyleConstant.Height.row + top, alignment: .bottom)
        .background(Color(UIColor.secondarySystemBackground))
        .border(Color(UIColor.systemGray5), width: 1)
        .zIndex(1)
    }
}
