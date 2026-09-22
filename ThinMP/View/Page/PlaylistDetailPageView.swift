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
        GeometryReader { geometry in
            ZStack(alignment: .top) {
                VStack(spacing: 0) {
                    ZStack(alignment: .top) {
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
                        ScrollView {
                            VStack(alignment: .leading) {
                                HeroHeaderView(headerRect: $headerRect, width: geometry.size.width, size: geometry.heroSize, top: geometry.safeAreaInsets.top, primaryText: vm.primaryText, secondaryText: NSLocalizedString(LabelConstant.playlist, comment: "")) {
                                    HeroSquareImageView(size: geometry.heroSize, artwork: vm.artwork)
                                }
                                SongListView(songs: vm.songs) { playlistRegisterSongId = $0 }
                            }
                        }
                    }
                    MiniPlayerView(bottom: geometry.safeAreaInsets.bottom) { vm.load(playlistId: playlistId) }
                }
                if let songId = playlistRegisterSongId {
                    PopupView {
                        PlaylistRegisterView(songId: songId, height: geometry.size.height) { playlistRegisterSongId = nil }
                    }
                }
            }
            .modifier(PageModifier())
            .task {
                await vm.load(playlistId: playlistId).value
            }
        }
    }
}
