//
//  PlaylistAddRowView.swift
//  ThinMP
//
//  Created by tk on 2021/04/12.
//

import MediaPlayer
import SwiftUI

struct PlaylistAddRowView<Content>: View where Content: View {
    let playlistId: PlaylistId
    let songId: SongId
    @Binding var showingPopup: Bool
    let content: () -> Content

    var body: some View {
        Button(action: {
            let playlistRegister = PlaylistRegister()

            playlistRegister.add(playlistId: playlistId, songId: songId)

            showingPopup.toggle()
        }) {
            content()
        }
    }
}
