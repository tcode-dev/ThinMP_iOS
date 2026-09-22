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
            Image("BackButton")
                .renderingMode(.original)
                .frame(width: StyleConstant.button, height: StyleConstant.button)
        }
        .frame(width: StyleConstant.button, height: StyleConstant.button)
    }
}
