//
//  MenuRowView.swift
//  ThinMP
//
//  Created by tk on 2021/07/10.
//

import SwiftUI

struct MenuRowView: View {
    let text: String

    var body: some View {
        HStack {
            MenuTextView(text)
            Spacer()
        }
        .frame(height: StyleConstant.Height.row)
        .padding(.leading, StyleConstant.Padding.tiny)
        .padding(.trailing, StyleConstant.Padding.tiny)
    }
}
