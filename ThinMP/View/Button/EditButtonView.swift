//
//  EditButtonView.swift
//  ThinMP
//
//  Created by tk on 2021/02/28.
//

import SwiftUI

struct EditButtonView<Content>: View where Content: View {
    let content: () -> Content

    @State var isEdit: Bool = false
    @State var editMode: EditMode = .active

    var body: some View {
        Menu {
            Button("Edit") {
                isEdit = true
            }
        } label: {
            MenuImageView()
        }
        .frame(width: StyleConstant.button, height: StyleConstant.button)
        .background(
            NavigationLink(destination: content().environment(\.editMode, $editMode), isActive: $isEdit) {
                EmptyView()
            })
    }
}
