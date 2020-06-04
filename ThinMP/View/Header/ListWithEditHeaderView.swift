//
//  SwiftUIView.swift
//  ThinMP
//
//  Created by tk on 2020/06/05.
//

import SwiftUI

struct ListWithEditHeaderView: View {
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
