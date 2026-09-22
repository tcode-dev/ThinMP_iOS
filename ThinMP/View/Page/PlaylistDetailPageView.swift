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
            HeroNavBarView(primaryText: vm.primaryText, width: geometry.size.width, top: geometry.safeAreaInsets.top, headerRect: $headerRect) {
                MenuButtonView {
                    VStack {
                        NavigationLink(destination: PlaylistDetailEditPageView(playlistId: playlistId, primaryText: vm.primaryText)) {
                            MenuRowView(text: LabelConstant.edit)
                        }
                        ShortcutButtonView(itemId: playlistId.id, type: .playlist)
                    }
                }
            }
        } content: { geometry in
            HeroHeaderView(headerRect: $headerRect, width: geometry.size.width, size: geometry.heroSize, top: geometry.safeAreaInsets.top, primaryText: vm.primaryText, secondaryText: NSLocalizedString(LabelConstant.playlist, comment: "")) {
                HeroSquareImageView(size: geometry.heroSize, artwork: vm.artwork)
            }
            SongListView(songs: vm.songs) { playlistRegisterSongId = $0 }
        }
        .task {
            await vm.load(playlistId: playlistId).value
        }
    }
}
