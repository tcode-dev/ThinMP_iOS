//
//  ListHeaderView.swift
//  ThinMP
//
//  Created by tk on 2020/06/01.
//

import SwiftUI

struct ListHeaderView: View {
    let heigt: CGFloat = 50

    var primaryText: String?
    var top: CGFloat

    var body: some View {
        HStack {
            BackButtonView()
            Spacer()
            PrimaryTextView(self.primaryText)
            Spacer()
        }
        .padding(.trailing, 50)
        .frame(height: heigt + top, alignment: .bottom)
        .background(Color(UIColor.secondarySystemBackground))
        .border(Color(UIColor.systemGray5), width: 1)
        .zIndex(1)
    }
}
