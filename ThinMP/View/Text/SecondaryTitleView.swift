//
//  SecondaryTitleView.swift
//  ThinMP
//
//  Created by tk on 2021/02/06.
//

import SwiftUI

struct SecondaryTitleView: View {
    private let text: String

    init(_ text: String?) {
        self.text = text ?? "unknown"
    }

    var body: some View {
        Text(text).font(.body).fontWeight(.medium).foregroundColor(.primary).lineLimit(1)
    }
}
