//
//  PlaylistDetailPageView.swift
//  ThinMP
//
//  Created by tk on 2021/03/30.
//

import SwiftUI

struct PlaylistDetailPageView: View {
    @State private var vm = PlaylistDetailViewModel()
    @State private var isScrolledUnder = false
    /// プレイリスト登録ポップアップを出している曲。nil ならポップアップは閉じている
    @State private var playlistRegisterSongId: SongId?

    let playlistId: PlaylistId

    var body: some View {
        ScrollPageLayout(playlistRegisterSongId: $playlistRegisterSongId, onPlayerDismiss: { vm.load(playlistId: playlistId) }) { geometry in
            HeroNavBarView(width: geometry.size.width, top: geometry.safeAreaInsets.top, isScrolledUnder: isScrolledUnder) {
                if let playlist = vm.playlist {
                    TitleView(playlist.primaryText)
                }
            } content: {
                MenuButtonView {
                    EditLinkView {
                        PlaylistDetailEditPageView(playlistId: playlistId, primaryText: vm.playlist?.primaryText)
                    }
                    ShortcutButtonView(target: .playlist(playlistId))
                }
            }
        } content: { geometry in
            HeroHeaderView(isScrolledUnder: $isScrolledUnder, width: geometry.size.width, size: geometry.heroSize, top: geometry.safeAreaInsets.top) {
                HeroSquareImageView(size: geometry.heroSize, artwork: vm.playlist?.artwork)
            } primaryText: {
                if let playlist = vm.playlist {
                    TitleView(playlist.primaryText)
                }
            } secondaryText: {
                if vm.playlist != nil {
                    SecondaryTextView(key: LabelConstant.playlist)
                }
            }
            SongListView(songs: vm.playlist?.songs ?? []) { playlistRegisterSongId = $0 }
        }
        .onAppear {
            vm.load(playlistId: playlistId)
        }
    }
}
