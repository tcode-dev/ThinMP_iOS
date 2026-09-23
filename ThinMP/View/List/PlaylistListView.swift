//
//  PlaylistListView.swift
//  ThinMP
//
//  Created by tk on 2026/09/23.
//

import SwiftUI

/// プレイリストの一覧。行をタップで詳細へ、長押しで削除とショートカットのメニューを出す
struct PlaylistListView: View {
    let playlists: [PlaylistModel]
    /// コンテキストメニューの削除が押されたときに呼ばれる
    let onDelete: (PlaylistId) -> Void

    var body: some View {
        LazyVStack(spacing: 0) {
            ForEach(playlists) { playlist in
                NavigationLink(destination: PlaylistDetailPageView(playlistId: playlist.playlistId)) {
                    MediaRowView(media: playlist)
                }
                .contentShape(RoundedRectangle(cornerRadius: StyleConstant.cornerRadius))
                .contextMenu {
                    PlaylistDeleteButtonView { onDelete(playlist.playlistId) }
                    ShortcutButtonView(target: .playlist(playlist.playlistId))
                }
                Divider()
            }
            .padding(.leading, StyleConstant.Padding.medium)
        }
    }
}
