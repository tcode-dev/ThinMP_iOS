//
//  SwiftUIView.swift
//  ThinMP
//
//  Created by tk on 2020/06/05.
//

import SwiftUI
import MediaPlayer

struct ListWithEditHeaderView: View {
    var id: MPMediaEntityPersistentID
    var primaryText: String?

    var body: some View {
        HStack {
            BackButtonView()
            Spacer()
            PrimaryTextView(self.primaryText)
            Spacer()
            MenuButtonView(id: id, primaryText: primaryText)
        }
        .frame(height: 50, alignment: .bottom)
    }
}
