//
//  BackButtonView.swift
//  ThinMP
//
//  Created by tk on 2020/01/24.
//

import SwiftUI

struct BackButtonView: View {
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        Button(action: {
            dismiss()
        }) {
            // サイズを指定しないと反応しない
            Image(.backButton)
                .renderingMode(.original)
                .frame(width: StyleConstant.button, height: StyleConstant.button)
                .accessibilityLabel(Text(.back))
        }
        .frame(width: StyleConstant.button, height: StyleConstant.button)
    }
}
