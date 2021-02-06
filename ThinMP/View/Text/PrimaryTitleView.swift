//
//  SectionHeaderTextView.swift
//  ThinMP
//
//  Created by tk on 2020/01/15.
//

import SwiftUI

struct PrimaryTitleView: View {
    private let text: String

    init(_ text: String?) {
        self.text = text ?? "unknown"
    }

    var body: some View {
        Text(text).font(.title).foregroundColor(.primary).lineLimit(1)
    }
}
