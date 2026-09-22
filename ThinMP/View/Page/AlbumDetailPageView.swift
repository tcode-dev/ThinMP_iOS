//
//  AlbumDetailPageView.swift
//  ThinMP
//
//  Created by tk on 2020/01/12.
//

import SwiftUI

struct AlbumDetailPageView: View {
    @StateObject private var vm = AlbumDetailViewModel()
    @State private var headerRect = CGRect.zero
    /// プレイリスト登録ポップアップを出している曲。nil ならポップアップは閉じている
    @State private var playlistRegisterSongId: SongId?

    let albumId: AlbumId

    var body: some View {
        ScrollPageLayout(playlistRegisterSongId: $playlistRegisterSongId) { geometry in
            HeroNavBarView(primaryText: vm.album?.primaryText, width: geometry.size.width, top: geometry.safeAreaInsets.top, headerRect: $headerRect) {
                MenuButtonView {
                    VStack {
                        ShortcutButtonView(albumId: albumId)
                    }
                }
            }
        } content: { geometry in
            HeroHeaderView(headerRect: $headerRect, width: geometry.size.width, size: geometry.heroSize, top: geometry.safeAreaInsets.top, primaryText: vm.album?.primaryText, secondaryText: vm.album?.secondaryText) {
                HeroSquareImageView(size: geometry.heroSize, artwork: vm.album?.artwork)
            }
            SongListView(songs: vm.album?.songs ?? []) { playlistRegisterSongId = $0 }
        }
        .task {
            await vm.load(albumId: albumId).value
        }
    }
}
