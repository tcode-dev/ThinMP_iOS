//
//  FavoriteArtistsMenuButtonView.swift
//  ThinMP
//
//  Created by tk on 2021/01/10.
//

import SwiftUI
import MediaPlayer

struct FavoriteArtistsMenuButtonView: View {
    @State var isOpen: Bool = false
    @State var isEdit: Bool = false

    var body: some View {
        Button(action: {
            self.isOpen.toggle()
        }) {
            MenuImageView()
        }
        .actionSheet(isPresented: $isOpen) {
            ActionSheet(title: Text("FavoriteArtists"),
                        buttons: [
                            .default(Text("Edit"), action: {
                                isEdit = true
                            }),
                            .cancel()
                        ])
        }
        .frame(width: 50, height: 50)
        NavigationLink(destination: FavoriteArtistsEditPageView(), isActive: $isEdit) {
            EmptyView()
        }
    }
}

