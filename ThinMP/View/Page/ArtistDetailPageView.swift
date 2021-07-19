//
//  ArtistDetailPageView.swift
//  ThinMP
//
//  Created by tk on 2020/01/07.
//

import MediaPlayer
import SwiftUI

struct ArtistDetailPageView: View {
    @StateObject private var vm = ArtistDetailViewModel()
    @State private var headerRect = CGRect()
    @State private var isRegister: Bool = false
    @State private var showingPopup: Bool = false
    @State private var playlistRegisterSongId = SongId(id: 0)

    let artistId: ArtistId

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .top) {
                VStack(spacing: 0) {
                    ZStack(alignment: .top) {
                        DetaiNavBarView(primaryText: vm.primaryText, side: geometry.size.width, top: geometry.safeAreaInsets.top, headerRect: $headerRect) {
                            MenuButtonView {
                                VStack {
                                    FavoriteArtistButtonView(artistId: artistId)
                                    ShortcutButtonView(itemId: artistId.id, type: ShortcutType.ARTIST)
                                }
                            }
                        }
                        ScrollView {
                            ArtistDetailHeaderView(vm: vm, headerRect: $headerRect, side: geometry.size.width, top: geometry.safeAreaInsets.top)
                            VStack(alignment: .leading) {
                                SectionTitleView("Albums")
                                    .padding(.leading, StyleConstant.Padding.large)
                                ArtistAlbumListView(list: vm.albums, width: geometry.size.width)
                                    .padding(.bottom, StyleConstant.Padding.large)
                                SectionTitleView("Songs")
                                    .padding(.leading, StyleConstant.Padding.large)
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
                                    }.padding(.leading, StyleConstant.Padding.large)
                                }
                            }
                        }
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
                vm.load(artistId: artistId)
            }
        }
    }
}
