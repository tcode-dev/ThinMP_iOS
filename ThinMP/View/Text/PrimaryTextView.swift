//
//  PrimaryTextView.swift
//  ThinMP
//
//  Created by tk on 2020/01/13.
//

import SwiftUI

struct PrimaryTextView: View {
    private let text: String

    init(_ text: String?) {
        if let text = text {
            self.text = text.isEmpty ? LabelConstant.unknown : text
        } else {
            self.text = LabelConstant.unknown
        }
    }

    var body: some View {
        Text(text)
            .font(.body)
            .foregroundColor(.primary)
            .lineLimit(1)
    }
}
