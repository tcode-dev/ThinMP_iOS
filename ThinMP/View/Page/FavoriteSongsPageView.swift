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
        GeometryReader { geometry in
            ZStack(alignment: .top) {
                VStack(spacing: 0) {
                    ZStack(alignment: .top) {
                        ListNavBarView(title: LabelConstant.favoriteSongs, top: geometry.safeAreaInsets.top, headerRect: $headerRect) {
                            EditButtonView {
                                FavoriteSongsEditPageView()
                            }
                        }
                        ScrollView {
                            VStack(alignment: .leading) {
                                ListEmptyHeaderView(headerRect: $headerRect, top: geometry.safeAreaInsets.top)
                                SongListView(songs: vm.songs, onFavoriteChange: { vm.load() }) { playlistRegisterSongId = $0 }
                            }
                        }
                    }
                    MiniPlayerView(bottom: geometry.safeAreaInsets.bottom) { vm.load() }
                }
                if let songId = playlistRegisterSongId {
                    PopupView {
                        PlaylistRegisterView(songId: songId, height: geometry.size.height) { playlistRegisterSongId = nil }
                    }
                }
            }
            .modifier(PageModifier())
            .task {
                await vm.load().value
            }
        }
    }
}
