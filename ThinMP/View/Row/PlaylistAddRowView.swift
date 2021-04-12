//
//  PlaylistAddRowView.swift
//  ThinMP
//
//  Created by tk on 2021/04/12.
//

import SwiftUI
import MediaPlayer

struct PlaylistAddRowView<Content> : View where Content: View {
    let playlistId: String
    let persistentId: MPMediaEntityPersistentID
    @Binding var showingPopup: Bool
    let content: () -> Content

    var body: some View {
        Button(action: {
            let playlistRegister = PlaylistRegister()

            playlistRegister.add(playlistId: playlistId, persistentId: persistentId)

            showingPopup.toggle()
        }) {
            content()
        }
    }
}
