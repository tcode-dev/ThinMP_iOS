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
    @State private var showingPopup: Bool = false
    @State private var playlistRegisterSongId = SongId(id: 0)

    let artistId: ArtistId

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .top) {
                VStack(spacing: 0) {
                    ZStack(alignment: .top) {
                        HeroNavBarView(primaryText: vm.primaryText, width: geometry.size.width, top: geometry.safeAreaInsets.top, headerRect: $headerRect) {
                            MenuButtonView {
                                VStack {
                                    FavoriteArtistButtonView(artistId: artistId)
                                    ShortcutButtonView(itemId: artistId.id, type: ShortcutType.ARTIST)
                                }
                            }
                        }
                        ScrollView {
                            HeroHeaderView(headerRect: $headerRect, width: geometry.size.width, height: geometry.size.height, top: geometry.safeAreaInsets.top, bottom: geometry.safeAreaInsets.bottom, primaryText: vm.primaryText, secondaryText: vm.secondaryText) {
                                HeroCircleImageView(width: geometry.size.width, height: geometry.size.height, top: geometry.safeAreaInsets.top, bottom: geometry.safeAreaInsets.bottom, artwork: vm.artwork)
                            }
                            VStack(alignment: .leading) {
                                if !vm.albums.isEmpty {
                                    SectionTitleView(LabelConstant.albums)
                                        .padding(.leading, StyleConstant.Padding.large)
                                    AlbumListView(albums: vm.albums, width: geometry.size.width)
                                        .padding(.bottom, StyleConstant.Padding.large)
                                }
                                if !vm.songs.isEmpty {
                                    SectionTitleView(LabelConstant.songs)
                                        .padding(.leading, StyleConstant.Padding.large)
                                    LazyVStack(spacing: 0) {
                                        ForEach(vm.songs.indices, id: \.self) { index in
                                            PlayRowView(list: vm.songs, index: index) {
                                                MediaRowView(media: vm.songs[index])
                                            }
                                            .contentShape(RoundedRectangle(cornerRadius: StyleConstant.cornerRadius))
                                            .contextMenu {
                                                FavoriteSongButtonView(songId: vm.songs[index].songId)
                                                Button(action: {
                                                    playlistRegisterSongId = vm.songs[index].songId
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
