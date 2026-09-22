//
//  PlaylistDetailPageView.swift
//  ThinMP
//
//  Created by tk on 2021/03/30.
//

import SwiftUI

struct PlaylistDetailPageView: View {
    @StateObject private var vm = PlaylistDetailViewModel()
    @State private var headerRect = CGRect.zero
    /// プレイリスト登録ポップアップを出している曲。nil ならポップアップは閉じている
    @State private var playlistRegisterSongId: SongId?

    let playlistId: PlaylistId

    var body: some View {
        ScrollPageLayout(playlistRegisterSongId: $playlistRegisterSongId, onPlayerDismiss: { vm.load(playlistId: playlistId) }) { geometry in
            HeroNavBarView(primaryText: vm.playlist?.primaryText, width: geometry.size.width, top: geometry.safeAreaInsets.top, headerRect: $headerRect) {
                MenuButtonView {
                    NavigationLink(destination: PlaylistDetailEditPageView(playlistId: playlistId, primaryText: vm.playlist?.primaryText)) {
                        MenuRowView(text: LabelConstant.edit)
                    }
                    ShortcutButtonView(target: .playlist(playlistId))
                }
            }
        } content: { geometry in
            HeroHeaderView(headerRect: $headerRect, width: geometry.size.width, size: geometry.heroSize, top: geometry.safeAreaInsets.top, primaryText: vm.playlist?.primaryText) {
                HeroSquareImageView(size: geometry.heroSize, artwork: vm.playlist?.artwork)
            } secondaryText: {
                SecondaryTextView(key: LabelConstant.playlist)
            }
            SongListView(songs: vm.playlist?.songs ?? []) { playlistRegisterSongId = $0 }
        }
        .task {
            await vm.load(playlistId: playlistId).value
        }
    }
}
