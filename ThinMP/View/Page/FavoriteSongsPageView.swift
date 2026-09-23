//
//  FavoriteSongsPageView.swift
//  ThinMP
//
//  Created by tk on 2021/02/23.
//

import SwiftUI

struct FavoriteSongsPageView: View {
    @StateObject private var vm = FavoriteSongsViewModel()
    @State private var isScrolledUnder = false
    /// プレイリスト登録ポップアップを出している曲。nil ならポップアップは閉じている
    @State private var playlistRegisterSongId: SongId?

    var body: some View {
        ScrollPageLayout(playlistRegisterSongId: $playlistRegisterSongId, onPlayerDismiss: { vm.load() }) { geometry in
            ListNavBarView(title: LabelConstant.favoriteSongs, top: geometry.safeAreaInsets.top, isScrolledUnder: isScrolledUnder) {
                EditButtonView {
                    FavoriteSongsEditPageView()
                }
            }
        } content: { geometry in
            ListEmptyHeaderView(isScrolledUnder: $isScrolledUnder, top: geometry.safeAreaInsets.top)
            SongListView(songs: vm.songs, onFavoriteChange: { vm.load() }) { playlistRegisterSongId = $0 }
        }
        .task {
            await vm.load().value
        }
    }
}
