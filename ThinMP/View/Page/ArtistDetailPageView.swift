//
//  ArtistDetailPageView.swift
//  ThinMP
//
//  Created by tk on 2020/01/07.
//

import SwiftUI

struct ArtistDetailPageView: View {
    @State private var vm = ArtistDetailViewModel()
    @State private var isScrolledUnder = false
    /// プレイリスト登録ポップアップを出している曲。nil ならポップアップは閉じている
    @State private var playlistRegisterSongId: SongId?

    let artistId: ArtistId

    var body: some View {
        ScrollPageLayout(playlistRegisterSongId: $playlistRegisterSongId) { geometry in
            HeroNavBarView(width: geometry.size.width, top: geometry.safeAreaInsets.top, isScrolledUnder: isScrolledUnder) {
                if let artist = vm.artist {
                    TitleView(artist.primaryText)
                }
            } content: {
                MenuButtonView {
                    FavoriteArtistButtonView(artistId: artistId)
                    ShortcutButtonView(target: .artist(artistId))
                }
            }
        } content: { geometry in
            HeroHeaderView(isScrolledUnder: $isScrolledUnder, width: geometry.size.width, size: geometry.heroSize, top: geometry.safeAreaInsets.top) {
                HeroCircleImageView(width: geometry.size.width, size: geometry.heroSize, artwork: vm.artist?.artwork)
            } primaryText: {
                if let artist = vm.artist {
                    TitleView(artist.primaryText)
                }
            } secondaryText: {
                if let artist = vm.artist {
                    SecondaryTextView(label: .albumsAndSongsCount(albums: artist.albums.count, songs: artist.songs.count))
                }
            }
            if let artist = vm.artist {
                if !artist.albums.isEmpty {
                    SectionTitleView(label: .albums)
                        .padding(.leading, StyleConstant.Padding.large)
                    AlbumListView(albums: artist.albums, width: geometry.size.width)
                        .padding(.bottom, StyleConstant.Padding.large)
                }
                if !artist.songs.isEmpty {
                    SectionTitleView(label: .songs)
                        .padding(.leading, StyleConstant.Padding.large)
                    SongListView(songs: artist.songs) { playlistRegisterSongId = $0 }
                }
            }
        }
        .task {
            await vm.load(artistId: artistId)
        }
    }
}
