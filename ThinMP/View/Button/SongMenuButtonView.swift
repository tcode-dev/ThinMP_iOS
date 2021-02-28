//
//  SongMenuButtonView.swift
//  ThinMP
//
//  Created by tk on 2021/02/20.
//

import SwiftUI
import MediaPlayer

struct SongMenuButtonView: View {
    let persistentId: MPMediaEntityPersistentID

    var body: some View {
        MenuButtonView {
            FavoriteSongButtonView(persistentId: persistentId)
        }
    }
}
