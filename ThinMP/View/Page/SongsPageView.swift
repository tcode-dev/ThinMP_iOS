//
//  SongsPageView.swift
//  ThinMP
//
//  Created by tk on 2020/01/13.
//

import MediaPlayer
import SwiftUI

struct SongsPageView: View {
    @StateObject private var vm = SongsViewModel()
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
                                HeaderTitleView("Songs")
                                Spacer()
                                Spacer()
                                    .frame(width: StyleConstant.button)
                            }
                        }
                        ScrollView {
                            VStack(alignment: .leading) {
                                ListEmptyHeaderView(headerRect: self.$headerRect, top: geometry.safeAreaInsets.top)
                                LazyVStack(spacing: 0) {
                                    ForEach(vm.songs.indices, id: \.self) { index in
                                        PlayRowView(list: vm.songs, index: index) {
                                            MediaRowView(media: vm.songs[index])
                                        }
                                        .contextMenu {
                                            FavoriteSongButtonView(songId: vm.songs[index].songId)
                                            Button(action: {
                                                playlistRegisterSongId = vm.songs[index].songId
                                                showingPopup.toggle()
                                            }) {
                                                Text("AddPlaylist")
                                            }
                                        }
                                        Divider()
                                    }
                                    .padding(.leading, StyleConstant.padding.medium)
                                }
                            }
                        }
                        .frame(alignment: .top)
                    }
                    MiniPlayerView(bottom: geometry.safeAreaInsets.bottom)
                }
                if showingPopup {
                    PopupView(showingPopup: $showingPopup) {
                        PlaylistRegisterView(songId: playlistRegisterSongId, height: geometry.size.height, showingPopup: $showingPopup)
                    }
                }
            }
            .navigationBarHidden(true)
            .navigationBarTitle(Text(""))
            .edgesIgnoringSafeArea(.all)
            .onAppear {
                vm.load()
            }
        }
    }
}
