//
//  SongsPageView.swift
//  ThinMP
//
//  Created by tk on 2020/01/13.
//

import SwiftUI

struct SongsPageView: View {
    @StateObject private var vm = SongsViewModel()
    @State private var isScrolledUnder = false
    /// プレイリスト登録ポップアップを出している曲。nil ならポップアップは閉じている
    @State private var playlistRegisterSongId: SongId?

    var body: some View {
        ScrollPageLayout(playlistRegisterSongId: $playlistRegisterSongId) { geometry in
            ListNavBarView(titleKey: LabelConstant.songs, top: geometry.safeAreaInsets.top, isScrolledUnder: isScrolledUnder)
        } content: { geometry in
            ListEmptyHeaderView(isScrolledUnder: $isScrolledUnder, top: geometry.safeAreaInsets.top)
            SongListView(songs: vm.songs) { playlistRegisterSongId = $0 }
        }
        .onFirstAppear {
            vm.load()
        }
    }
}
