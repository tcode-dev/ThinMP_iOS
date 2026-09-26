//
//  MainTitleView.swift
//  ThinMP
//
//  Created by tk on 2021/07/15.
//

import SwiftUI

struct MainTitleView: View {
    private let text: Text

    /// String Catalog のラベル
    init(label: LocalizedStringResource) {
        text = Text(label)
    }

    var body: some View {
        text
            .fontWeight(.bold)
            .font(.largeTitle)
    }
}
