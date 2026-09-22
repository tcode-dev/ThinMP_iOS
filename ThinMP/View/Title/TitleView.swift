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

    /// Localizable.strings のキー。Model / Service は翻訳しないので、ラベルの翻訳はここで行う
    init(key: String) {
        text = Text(LocalizedStringKey(key))
    }

    var body: some View {
        text
            .font(.body)
            .fontWeight(.medium)
            .foregroundColor(.primary)
            .lineLimit(1)
    }
}
