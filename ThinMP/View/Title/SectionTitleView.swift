//
//  SectionTitleView.swift
//  ThinMP
//
//  Created by tk on 2020/01/15.
//

import SwiftUI

struct SectionTitleView: View {
    private let text: Text

    /// String Catalog のラベル
    init(label: LocalizedStringResource) {
        text = Text(label)
    }

    var body: some View {
        text
            .font(.title)
            .foregroundStyle(Color.primary)
            .lineLimit(1)
    }
}
