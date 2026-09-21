//
//  PlaylistDetailPageView.swift
//  ThinMP
//
//  Created by tk on 2021/03/30.
//

import MediaPlayer
import SwiftUI

struct PlaylistDetailPageView: View {
    @StateObject private var vm = PlaylistDetailViewModel()
    @State private var headerRect = CGRect.zero
    @State private var showingPopup: Bool = false
    @State private var playlistRegisterSongId = SongId(id: 0)
    @State var isEdit: Bool = false
    @State var editMode: EditMode = .active

    let playlistId: PlaylistId

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .top) {
                VStack(spacing: 0) {
                    ZStack(alignment: .top) {
                        HeroNavBarView(primaryText: vm.primaryText, width: geometry.size.width, top: geometry.safeAreaInsets.top, headerRect: $headerRect) {
                            VStack {
                                MenuButtonView {
                                    VStack {
                                        NavigationLink(destination: PlaylistDetailEditPageView(playlistId: playlistId, primaryText: vm.primaryText)) {
                                            MenuRowView(text: LabelConstant.edit)
                                        }
                                        ShortcutButtonView(itemId: playlistId.id, type: ShortcutType.PLAYLIST)
                                    }
                                }
                            }
                        }
                        ScrollView {
                            VStack(alignment: .leading) {
                                HeroHeaderView(headerRect: $headerRect, width: geometry.size.width, height: geometry.size.height, top: geometry.safeAreaInsets.top, bottom: geometry.safeAreaInsets.bottom, primaryText: vm.primaryText, secondaryText: LabelConstant.playlist) {
                                    HeroSquareImageView(width: geometry.size.width, height: geometry.size.height, top: geometry.safeAreaInsets.top, bottom: geometry.safeAreaInsets.bottom, artwork: vm.artwork)
                                }
                                LazyVStack(spacing: 0) {
                                    ForEach(Array(vm.songs.enumerated()), id: \.element.id) { index, song in
                                        PlayRowView(list: vm.songs, index: index) {
                                            MediaRowView(media: song)
                                        }
                                        .contentShape(RoundedRectangle(cornerRadius: StyleConstant.cornerRadius))
                                        .contextMenu {
                                            FavoriteSongButtonView(songId: song.songId)
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
                    }
                    MiniPlayerView(bottom: geometry.safeAreaInsets.bottom) { vm.load(playlistId: playlistId) }
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
                vm.load(playlistId: playlistId)
            }
        }
    }
}
