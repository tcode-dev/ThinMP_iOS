//
//  SectionTitleView.swift
//  ThinMP
//
//  Created by tk on 2020/01/15.
//

import SwiftUI

struct SectionTitleView: View {
    private let text: Text

    /// Localizable.strings のキー。Model / Service は翻訳しないので、ラベルの翻訳はここで行う
    init(key: String) {
        text = Text(label: key)
    }

    var body: some View {
        text
            .font(.title)
            .foregroundColor(.primary)
            .lineLimit(1)
    }
}
