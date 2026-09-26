//
//  TitleView.swift
//  ThinMP
//
//  Created by tk on 2021/02/06.
//

import SwiftUI

struct TitleView: View {
    private let text: Text

    /// ライブラリの文字列(アルバム名など)。nil か空なら「不明」
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
            .fontWeight(.medium)
            .foregroundStyle(Color.primary)
            .lineLimit(1)
    }
}
