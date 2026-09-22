//
//  SongsPageView.swift
//  ThinMP
//
//  Created by tk on 2020/01/13.
//

import SwiftUI

struct SongsPageView: View {
    @StateObject private var vm = SongsViewModel()
    @State private var headerRect = CGRect.zero
    /// プレイリスト登録ポップアップを出している曲。nil ならポップアップは閉じている
    @State private var playlistRegisterSongId: SongId?

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .top) {
                VStack(spacing: 0) {
                    ZStack(alignment: .top) {
                        ListNavBarView(title: LabelConstant.songs, top: geometry.safeAreaInsets.top, headerRect: $headerRect)
                        ScrollView {
                            VStack(alignment: .leading) {
                                ListEmptyHeaderView(headerRect: $headerRect, top: geometry.safeAreaInsets.top)
                                SongListView(songs: vm.songs) { playlistRegisterSongId = $0 }
                            }
                        }
                    }
                    MiniPlayerView(bottom: geometry.safeAreaInsets.bottom)
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
