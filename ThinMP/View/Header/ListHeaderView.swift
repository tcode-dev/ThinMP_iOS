//
//  ListHeaderView.swift
//  ThinMP
//
//  Created by tk on 2020/06/01.
//

import SwiftUI

struct ListHeaderView: View {
    var primaryText: String?

    var body: some View {
        HStack {
            BackButtonView()
            Spacer()
            PrimaryTextView(self.primaryText)
            Spacer()
            MenuButtonView()
        }
        .frame(height: 50, alignment: .bottom)
    }
}
