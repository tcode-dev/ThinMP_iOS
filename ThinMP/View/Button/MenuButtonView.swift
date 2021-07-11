//
//  MenuButtonView.swift
//  ThinMP
//
//  Created by tk on 2020/01/24.
//

import SwiftUI

struct MenuButtonView<Content>: View where Content: View {
    let content: () -> Content

    var body: some View {
        Menu {
            content()
        } label: {
            MenuImageView()
        }
        .frame(width: StyleConstant.button, height: StyleConstant.button)
    }
}
