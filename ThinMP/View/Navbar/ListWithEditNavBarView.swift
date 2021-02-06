//
//  ListWithEditNavBarView.swift
//  ThinMP
//
//  Created by tk on 2020/06/05.
//

import SwiftUI
import MediaPlayer

struct ListWithEditNavBarView: View {
    var persistentId: MPMediaEntityPersistentID
    var primaryText: String?

    var body: some View {
        HStack {
            BackButtonView()
            Spacer()
            PrimaryTextView(self.primaryText)
            Spacer()
            MenuButtonView(persistentId: persistentId, primaryText: primaryText)
        }
        .frame(height: 50, alignment: .bottom)
    }
}
