//
//  FavoriteSongsPageView.swift
//  ThinMP
//
//  Created by tk on 2021/02/23.
//

import MediaPlayer
import SwiftUI

struct FavoriteSongsPageView: View {
    @StateObject private var vm = FavoriteSongsViewModel()
    @State private var headerRect = CGRect()
    @State private var showingPopup: Bool = false
    @State private var playlistRegisterSongId = SongId(id: 0)

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .top) {
                VStack(spacing: 0) {
                    ZStack(alignment: .top) {
                        ListNavBarView(top: geometry.safeAreaInsets.top, rect: $headerRect) {
                            HStack {
                                BackButtonView()
                                Spacer()
                                HeaderTitleView(LabelConstant.favoriteSongs)
                                Spacer()
                                EditButtonView {
                                    FavoriteSongsEditPageView()
                                }
                            }
                        }
                        ScrollView {
                            VStack(alignment: .leading) {
                                ListEmptyHeaderView(headerRect: $headerRect, top: geometry.safeAreaInsets.top)
                                LazyVStack(spacing: 0) {
                                    ForEach(Array(vm.songs.enumerated()), id: \.element.id) { index, song in
                                        PlayRowView(list: vm.songs, index: index) {
                                            MediaRowView(media: song)
                                        }
                                        .contentShape(RoundedRectangle(cornerRadius: StyleConstant.cornerRadius))
                                        .contextMenu {
                                            FavoriteSongButtonView(songId: song.songId) { vm.load() }
                                            Button(action: {
                                                playlistRegisterSongId = song.songId
                                                showingPopup.toggle()
                                            }) {
                                                Text(LocalizedStringKey(LabelConstant.addPlaylist))
                                            }
                                        }
                                        Divider()
                                    }
                                    .padding(.leading, StyleConstant.Padding.medium)
                                }
                            }
                        }
                        .frame(alignment: .top)
                    }
                    MiniPlayerView(bottom: geometry.safeAreaInsets.bottom) { vm.load() }
                }
                if showingPopup {
                    PopupView(showingPopup: $showingPopup) {
                        PlaylistRegisterView(songId: playlistRegisterSongId, height: geometry.size.height, showingPopup: $showingPopup)
                    }
                }
            }
            .toolbar(.hidden, for: .navigationBar)
            .navigationTitle("")
            .ignoresSafeArea(.container)
            .onAppear {
                vm.load()
            }
        }
    }
}
