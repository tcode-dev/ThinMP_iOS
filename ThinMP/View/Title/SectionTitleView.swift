//
//  SectionTitleView.swift
//  ThinMP
//
//  Created by tk on 2020/01/15.
//

import SwiftUI

struct SectionTitleView: View {
    private let text: String

    init(_ text: String) {
        self.text = text
    }

    var body: some View {
        Text(LocalizedStringKey(text)).font(.title).foregroundColor(.primary).lineLimit(1)
    }
}
