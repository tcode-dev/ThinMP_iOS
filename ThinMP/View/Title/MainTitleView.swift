//
//  MainTitleView.swift
//  ThinMP
//
//  Created by tk on 2021/07/15.
//

import SwiftUI

struct MainTitleView: View {
    private let text: String

    init(_ text: String) {
        self.text = text
    }

    var body: some View {
        Text(LocalizedStringKey(text))
            .fontWeight(.bold)
            .font(.largeTitle)
    }
}
