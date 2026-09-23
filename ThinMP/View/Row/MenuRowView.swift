//
//  MenuRowView.swift
//  ThinMP
//
//  Created by tk on 2021/07/10.
//

import SwiftUI

struct MenuRowView: View {
    let key: String

    var body: some View {
        HStack {
            PrimaryTextView(key: key)
            Spacer()
        }
        .modifier(RowModifier())
    }
}
