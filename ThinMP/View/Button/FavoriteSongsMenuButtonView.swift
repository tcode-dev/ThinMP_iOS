//
//  FavoriteSongsMenuButtonView.swift
//  ThinMP
//
//  Created by tk on 2021/02/28.
//

import SwiftUI
import MediaPlayer

struct FavoriteSongsMenuButtonView: View {
    var BUTTON_TEXT: String = "Edit"

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
            NavigationLink(destination: FavoriteSongsEditPageView().environment(\.editMode, $editMode), isActive: $isEdit) {
                EmptyView()
            })
    }
}

