//
//  EditButtonView.swift
//  ThinMP
//
//  Created by tk on 2021/02/28.
//

import SwiftUI

struct EditButtonView<Content>: View where Content: View {
    let content: () -> Content
    
    var body: some View {
        Menu {
            NavigationLink(destination: content()) {
                MenuRowView(text: LabelConstant.edit)
            }
        } label: {
            MenuImageView()
        }
        .frame(width: StyleConstant.button, height: StyleConstant.button)
    }
}
