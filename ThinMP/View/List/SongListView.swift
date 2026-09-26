//
//  SongListView.swift
//  ThinMP
//
//  Created by tk on 2026/09/22.
//

import SwiftUI

/// 曲の一覧。行をタップで再生、長押しでお気に入りとプレイリスト登録のメニューを出す
struct SongListView: View {
    let songs: [SongModel]
    /// お気に入りの登録・解除後に呼ばれる(一覧の再読み込みなど)
    var onFavoriteChange: () -> Void = {}
    /// プレイリスト登録ポップアップは画面全体に被せるので、開く曲だけをページに渡す
    let onAddPlaylist: (SongId) -> Void

    var body: some View {
        LazyVStack(spacing: 0) {
            ForEach(Array(songs.enumerated()), id: \.element.id) { index, song in
                PlayRowView(list: songs, index: index) {
                    MediaRowView(media: song)
                }
                .contentShape(RoundedRectangle(cornerRadius: StyleConstant.cornerRadius))
                .contextMenu {
                    FavoriteSongButtonView(songId: song.songId, onToggle: onFavoriteChange)
                    Button(action: {
                        onAddPlaylist(song.songId)
                    }) {
                        Text(.addPlaylist)
                    }
                }
                Divider()
            }
            .padding(.leading, StyleConstant.Padding.medium)
        }
    }
}
