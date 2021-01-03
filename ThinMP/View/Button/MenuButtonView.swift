//
//  MenuButtonView.swift
//  ThinMP
//
//  Created by tk on 2020/01/24.
//

import SwiftUI
import MediaPlayer

struct MenuButtonView: View {
    var id: MPMediaEntityPersistentID
    var primaryText: String?
    @State var isOpen: Bool = false

    var body: some View {
        Button(action: {
            self.isOpen.toggle()
        }) {
            MenuImageView()
        }
        .actionSheet(isPresented: $isOpen) {
            ActionSheet(title: Text(self.primaryText ?? ""),
                        buttons: [
                            .default(Text("お気に入りアーティストに追加"), action: {
                                let favoriteArtistRegister = FavoriteArtistRegister()

                                favoriteArtistRegister.add(id: id)
                            }),
                            .default(Text("Option 2"), action: {
                                NSLog("clicked Option 2")
                            }),
                            .cancel()
            ])
        }
        .frame(width: 50, height: 50)
    }
}
