//
//  HeaderTitleView.swift
//  ThinMP
//
//  Created by tk on 2021/07/10.
//

import SwiftUI

struct HeaderTitleView: View {
    private let text: String

    init(_ text: String) {
        self.text = text
    }

    var body: some View {
        Text(LocalizedStringKey(text))
            .font(.body)
            .fontWeight(.medium)
            .foregroundColor(.primary)
            .lineLimit(1)
    }
}
