//
//  EditButtonView.swift
//  ThinMP
//
//  Created by tk on 2021/02/28.
//

import SwiftUI

struct EditButtonView<Content> : View where Content: View {
    var BUTTON_TEXT: String = "Edit"

    let content: () -> Content

    @State var isEdit: Bool = false
    @State var editMode: EditMode = .active

    var body: some View {
        Menu {
            Button(BUTTON_TEXT) {
                self.isEdit = true
            }
        } label: {
            MenuImageView()
                .frame(width: 50, height: 50)
        }
        .background(
            NavigationLink(destination: content().environment(\.editMode, $editMode), isActive: $isEdit) {
                EmptyView()
            })
    }
}
