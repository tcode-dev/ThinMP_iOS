//
//  MenuButtonView.swift
//  ThinMP
//
//  Created by tk on 2020/01/24.
//

import SwiftUI

struct MenuButtonView: View {
    var body: some View {
        Button(action: {
        }) {
            Image("MenuButton")
                .renderingMode(.original)
        }
        .frame(width: 50, height: 50)
    }
}
