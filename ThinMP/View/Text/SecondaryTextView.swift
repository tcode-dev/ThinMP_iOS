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

    /// Localizable.strings のキーと、その書式に埋める引数("%d albums, %d songs" など)
    /// Model / Service は翻訳しないので、ラベルの翻訳はここで行う
    /// 単数 / 複数で文言が変わるキーは Localizable.stringsdict にある
    /// locale を渡さないと stringsdict の単数形が選ばれず "1 albums" になる(LocalizationTests)
    init(key: String, _ arguments: CVarArg...) {
        text = Text(String(format: NSLocalizedString(key, comment: ""), locale: .current, arguments: arguments))
    }

    var body: some View {
        text
            .font(.subheadline)
            .foregroundStyle(.secondary)
            .lineLimit(1)
    }
}
