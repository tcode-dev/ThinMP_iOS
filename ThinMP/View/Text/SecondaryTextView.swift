//
//  SecondaryTextView.swift
//  ThinMP
//
//  Created by tk on 2020/01/13.
//

import SwiftUI

struct SecondaryTextView: View {
    private let text: String

    /// ライブラリの文字列(アーティスト名など)。nil か空なら「不明」
    init(_ text: String?) {
        self.text = text.orUnknown
    }

    /// Localizable.strings のキーと、その書式に埋める引数("%d albums, %d songs" など)
    /// Model / Service は翻訳しないので、ラベルの翻訳はここで行う
    init(key: String, _ arguments: CVarArg...) {
        text = String(format: NSLocalizedString(key, comment: ""), arguments: arguments)
    }

    var body: some View {
        Text(text)
            .font(.subheadline)
            .foregroundColor(.secondary)
            .lineLimit(1)
    }
}
