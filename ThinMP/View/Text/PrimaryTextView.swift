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

    /// Localizable.strings のキー。Model / Service は翻訳しないので、ラベルの翻訳はここで行う
    init(key: String) {
        text = Text(label: key)
    }

    var body: some View {
        text
            .font(.body)
            .foregroundStyle(.primary)
            .lineLimit(1)
    }
}
