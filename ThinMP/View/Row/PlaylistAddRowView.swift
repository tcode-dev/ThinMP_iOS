//
//  PlaylistAddRowView.swift
//  ThinMP
//
//  Created by tk on 2021/04/12.
//

import SwiftUI

struct PlaylistAddRowView<Content>: View where Content: View {
    let playlistId: PlaylistId
    let songId: SongId
    /// すでにこの曲が入っているプレイリストはグレーアウトしてタップ不可にする
    let isRegistered: Bool
    @Binding var showingPopup: Bool
    let content: () -> Content

    var body: some View {
        Button(action: {
            let playlistRegister = PlaylistRegister()

            playlistRegister.add(playlistId: playlistId, songId: songId)

            showingPopup.toggle()
        }) {
            HStack {
                content()
                if isRegistered {
                    Text(LocalizedStringKey(LabelConstant.registered))
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .padding(.trailing, StyleConstant.Padding.tiny)
                }
            }
        }
        .disabled(isRegistered)
        .opacity(isRegistered ? 0.4 : 1)
    }
}
