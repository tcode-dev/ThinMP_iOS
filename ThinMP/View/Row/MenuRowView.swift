//
//  MenuRowView.swift
//  ThinMP
//
//  Created by tk on 2021/07/10.
//

import SwiftUI

struct MenuRowView: View {
    let label: LocalizedStringResource

    var body: some View {
        HStack {
            PrimaryTextView(label: label)
            Spacer()
        }
        .modifier(RowModifier())
    }
}
