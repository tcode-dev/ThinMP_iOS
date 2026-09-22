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
            HeroNavBarView(primaryText: vm.primaryText, width: geometry.size.width, top: geometry.safeAreaInsets.top, headerRect: $headerRect) {
                MenuButtonView {
                    VStack {
                        ShortcutButtonView(albumId: albumId)
                    }
                }
            }
        } content: { geometry in
            HeroHeaderView(headerRect: $headerRect, width: geometry.size.width, size: geometry.heroSize, top: geometry.safeAreaInsets.top, primaryText: vm.primaryText, secondaryText: vm.secondaryText) {
                HeroSquareImageView(size: geometry.heroSize, artwork: vm.artwork)
            }
            SongListView(songs: vm.songs) { playlistRegisterSongId = $0 }
        }
        .task {
            await vm.load(albumId: albumId).value
        }
    }
}
