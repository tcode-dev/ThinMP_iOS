//
//  FavoriteSongsPageView.swift
//  ThinMP
//
//  Created by tk on 2021/02/23.
//

import SwiftUI

struct FavoriteSongsPageView: View {
    @StateObject private var vm = FavoriteSongsViewModel()
    @State private var headerRect = CGRect.zero
    /// プレイリスト登録ポップアップを出している曲。nil ならポップアップは閉じている
    @State private var playlistRegisterSongId: SongId?

    var body: some View {
        ScrollPageLayout(playlistRegisterSongId: $playlistRegisterSongId, onPlayerDismiss: { vm.load() }) { geometry in
            ListNavBarView(title: LabelConstant.favoriteSongs, top: geometry.safeAreaInsets.top, headerRect: $headerRect) {
                EditButtonView {
                    FavoriteSongsEditPageView()
                }
            }
        } content: { geometry in
            ListEmptyHeaderView(headerRect: $headerRect, top: geometry.safeAreaInsets.top)
            SongListView(songs: vm.songs, onFavoriteChange: { vm.load() }) { playlistRegisterSongId = $0 }
        }
        .task {
            await vm.load().value
        }
    }
}
