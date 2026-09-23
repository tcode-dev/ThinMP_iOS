//
//  AlbumDetailPageView.swift
//  ThinMP
//
//  Created by tk on 2020/01/12.
//

import SwiftUI

struct AlbumDetailPageView: View {
    @StateObject private var vm = AlbumDetailViewModel()
    @State private var isScrolledUnder = false
    /// プレイリスト登録ポップアップを出している曲。nil ならポップアップは閉じている
    @State private var playlistRegisterSongId: SongId?

    let albumId: AlbumId

    var body: some View {
        ScrollPageLayout(playlistRegisterSongId: $playlistRegisterSongId) { geometry in
            HeroNavBarView(primaryText: vm.album?.primaryText, width: geometry.size.width, top: geometry.safeAreaInsets.top, isScrolledUnder: isScrolledUnder) {
                MenuButtonView {
                    ShortcutButtonView(target: .album(albumId))
                }
            }
        } content: { geometry in
            HeroHeaderView(isScrolledUnder: $isScrolledUnder, width: geometry.size.width, size: geometry.heroSize, top: geometry.safeAreaInsets.top, primaryText: vm.album?.primaryText) {
                HeroSquareImageView(size: geometry.heroSize, artwork: vm.album?.artwork)
            } secondaryText: {
                SecondaryTextView(vm.album?.secondaryText)
            }
            SongListView(songs: vm.album?.songs ?? []) { playlistRegisterSongId = $0 }
        }
        .task {
            await vm.load(albumId: albumId).value
        }
    }
}
