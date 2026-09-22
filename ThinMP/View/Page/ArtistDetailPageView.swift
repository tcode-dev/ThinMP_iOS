//
//  ArtistDetailPageView.swift
//  ThinMP
//
//  Created by tk on 2020/01/07.
//

import SwiftUI

struct ArtistDetailPageView: View {
    @StateObject private var vm = ArtistDetailViewModel()
    @State private var headerRect = CGRect.zero
    /// プレイリスト登録ポップアップを出している曲。nil ならポップアップは閉じている
    @State private var playlistRegisterSongId: SongId?

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
                            VStack(alignment: .leading) {
                                HeroHeaderView(headerRect: $headerRect, width: geometry.size.width, height: geometry.size.height, top: geometry.safeAreaInsets.top, bottom: geometry.safeAreaInsets.bottom, primaryText: vm.primaryText, secondaryText: vm.secondaryText) {
                                    HeroCircleImageView(width: geometry.size.width, height: geometry.size.height, top: geometry.safeAreaInsets.top, bottom: geometry.safeAreaInsets.bottom, artwork: vm.artwork)
                                }
                                if !vm.albums.isEmpty {
                                    SectionTitleView(LabelConstant.albums)
                                        .padding(.leading, StyleConstant.Padding.large)
                                    AlbumListView(albums: vm.albums, width: geometry.size.width)
                                        .padding(.bottom, StyleConstant.Padding.large)
                                }
                                if !vm.songs.isEmpty {
                                    SectionTitleView(LabelConstant.songs)
                                        .padding(.leading, StyleConstant.Padding.large)
                                    SongListView(songs: vm.songs) { playlistRegisterSongId = $0 }
                                }
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
            .toolbar(.hidden, for: .navigationBar)
            .navigationTitle("")
            .ignoresSafeArea(.container)
            .task {
                await vm.load(artistId: artistId).value
            }
        }
    }
}
