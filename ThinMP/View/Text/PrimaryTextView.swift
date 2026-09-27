//
//  PrimaryTextView.swift
//  ThinMP
//
//  Created by tk on 2020/01/13.
//

import SwiftUI

struct PrimaryTextView: View {
    private let text: Text

    /// ライブラリの文字列(曲名など)。nil か空なら「不明」
    init(_ text: String?) {
        self.text = Text(text.orUnknown)
    }

    /// String Catalog のラベル
    init(label: LocalizedStringResource) {
        text = Text(label)
    }

    var body: some View {
        text
            .font(.body)
            .foregroundStyle(Color.primary)
            .lineLimit(1)
    }
}
