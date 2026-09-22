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
            PrimaryTextView(key: text)
            Spacer()
        }
        .modifier(RowModifier())
    }
}
