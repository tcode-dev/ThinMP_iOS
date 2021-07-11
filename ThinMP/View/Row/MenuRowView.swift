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
            VStack(alignment: .leading) {
                Text(LocalizedStringKey(text)).font(.body).foregroundColor(.primary).lineLimit(1)
            }
            .frame(height: 34)
            Spacer()
        }
        .padding(StyleConstant.Padding.small)
    }
}
