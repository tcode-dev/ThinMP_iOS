//
//  FavoriteSongsMenuButtonView.swift
//  ThinMP
//
//  Created by tk on 2021/02/28.
//

import SwiftUI
import MediaPlayer

struct FavoriteSongsMenuButtonView: View {
    @State var isOpen: Bool = false
    @State var isEdit: Bool = false
    @State var editMode: EditMode = .active
    
    var body: some View {
        Menu {
            PrimaryTextView("Edit")
        } label: {
            MenuImageView()
                .frame(width: 50, height: 50)
        }
    }
}

