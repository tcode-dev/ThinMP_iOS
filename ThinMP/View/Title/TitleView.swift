//
//  TitleView.swift
//  ThinMP
//
//  Created by tk on 2021/02/06.
//

import SwiftUI

struct TitleView: View {
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
            .fontWeight(.medium)
            .foregroundColor(.primary)
            .lineLimit(1)
    }
}
