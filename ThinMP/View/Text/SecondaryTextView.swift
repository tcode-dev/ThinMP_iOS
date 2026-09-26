//
//  SecondaryTextView.swift
//  ThinMP
//
//  Created by tk on 2020/01/13.
//

import SwiftUI

struct SecondaryTextView: View {
    private let text: Text

    /// ライブラリの文字列(アーティスト名など)。nil か空なら「不明」
    init(_ text: String?) {
        self.text = Text(text.orUnknown)
    }

    /// String Catalog のラベル
    init(label: LocalizedStringResource) {
        text = Text(label)
    }

    var body: some View {
        text
            .font(.subheadline)
            .foregroundStyle(Color.secondary)
            .lineLimit(1)
    }
}
