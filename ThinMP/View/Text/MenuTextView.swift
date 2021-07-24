//
//  MenuTextView.swift
//  ThinMP
//
//  Created by tk on 2021/07/15.
//

import SwiftUI

struct MenuTextView: View {
    private let text: String

    init(_ text: String) {
        self.text = text
    }

    var body: some View {
        Text(LocalizedStringKey(text))
            .font(.body)
            .foregroundColor(.primary)
            .lineLimit(1)
    }
}
