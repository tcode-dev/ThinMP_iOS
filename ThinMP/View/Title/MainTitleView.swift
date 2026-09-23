//
//  MainTitleView.swift
//  ThinMP
//
//  Created by tk on 2021/07/15.
//

import SwiftUI

struct MainTitleView: View {
    private let text: Text

    /// Localizable.strings のキー。Model / Service は翻訳しないので、ラベルの翻訳はここで行う
    init(key: String) {
        text = Text(label: key)
    }

    var body: some View {
        text
            .fontWeight(.bold)
            .font(.largeTitle)
    }
}
