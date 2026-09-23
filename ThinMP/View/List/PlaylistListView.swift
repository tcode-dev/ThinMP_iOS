//
//  PlaylistListView.swift
//  ThinMP
//
//  Created by tk on 2026/09/23.
//

import SwiftUI

/// プレイリストの一覧。行をタップで詳細へ、長押しで削除とショートカットのメニューを出す
/// 削除は元に戻せないので、確認のダイアログを挟む
struct PlaylistListView: View {
    /// 削除の確認を出しているプレイリスト。nil なら確認は閉じている
    @State private var deletingPlaylist: PlaylistModel?

    let playlists: [PlaylistModel]
    /// 削除の確認で削除が押されたときに呼ばれる
    let onDelete: (PlaylistId) -> Void

    var body: some View {
        LazyVStack(spacing: 0) {
            ForEach(playlists) { playlist in
                NavigationLink(destination: PlaylistDetailPageView(playlistId: playlist.playlistId)) {
                    MediaRowView(media: playlist, showsSecondaryText: false)
                }
                .contentShape(RoundedRectangle(cornerRadius: StyleConstant.cornerRadius))
                .contextMenu {
                    PlaylistDeleteButtonView { deletingPlaylist = playlist }
                    ShortcutButtonView(target: .playlist(playlist.playlistId))
                }
                Divider()
            }
            .padding(.leading, StyleConstant.Padding.medium)
        }
        .confirmationDialog(deletingPlaylist?.primaryText.orUnknown ?? "", isPresented: isDeleteConfirmationPresented, titleVisibility: .visible, presenting: deletingPlaylist) { playlist in
            PlaylistDeleteButtonView { onDelete(playlist.playlistId) }
        }
    }

    /// 閉じたときは deletingPlaylist を nil に戻す
    private var isDeleteConfirmationPresented: Binding<Bool> {
        return Binding(get: { deletingPlaylist != nil }, set: { isPresented in
            if !isPresented {
                deletingPlaylist = nil
            }
        })
    }
}
