//
//  MenuButtonView.swift
//  ThinMP
//
//  Created by tk on 2020/01/24.
//

import SwiftUI
import MediaPlayer

struct MenuButtonView: View {
    var persistentId: MPMediaEntityPersistentID
    var primaryText: String?
    var ADD_TEXT: String = "お気に入りアーティストに追加"
    var DELETE_TEXT: String = "お気に入りアーティストから削除"
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
                            favoriteArtistButton(),
                            .default(Text("Option 2"), action: {
                                NSLog("clicked Option 2")
                            }),
                            .cancel()
            ])
        }
        .frame(width: 50, height: 50)
    }

    func favoriteArtistButton() -> ActionSheet.Button {
        let favoriteArtistRegister = FavoriteArtistRegister()

        if (!favoriteArtistRegister.exists(persistentId: persistentId)) {
            // add
            return ActionSheet.Button.default(Text(ADD_TEXT), action: {favoriteArtistRegister.add(persistentId: persistentId)})
        } else {
            // delete
            return ActionSheet.Button.default(Text(DELETE_TEXT), action: {favoriteArtistRegister.delete(persistentId: persistentId)})
        }
    }
}
