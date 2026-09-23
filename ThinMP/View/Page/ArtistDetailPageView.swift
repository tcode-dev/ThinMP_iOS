//
//  ArtistDetailPageView.swift
//  ThinMP
//
//  Created by tk on 2020/01/07.
//

import SwiftUI

struct ArtistDetailPageView: View {
    @StateObject private var vm = ArtistDetailViewModel()
    @State private var isScrolledUnder = false
    /// プレイリスト登録ポップアップを出している曲。nil ならポップアップは閉じている
    @State private var playlistRegisterSongId: SongId?

    let artistId: ArtistId

    var body: some View {
        ScrollPageLayout(playlistRegisterSongId: $playlistRegisterSongId) { geometry in
            HeroNavBarView(primaryText: vm.artist?.primaryText, width: geometry.size.width, top: geometry.safeAreaInsets.top, isScrolledUnder: isScrolledUnder) {
                MenuButtonView {
                    FavoriteArtistButtonView(artistId: artistId)
                    ShortcutButtonView(target: .artist(artistId))
                }
            }
        } content: { geometry in
            HeroHeaderView(isScrolledUnder: $isScrolledUnder, width: geometry.size.width, size: geometry.heroSize, top: geometry.safeAreaInsets.top, primaryText: vm.artist?.primaryText) {
                HeroCircleImageView(width: geometry.size.width, size: geometry.heroSize, artwork: vm.artist?.artwork)
            } secondaryText: {
                if let artist = vm.artist {
                    SecondaryTextView(key: LabelConstant.albumsAndSongsCount, artist.albums.count, artist.songs.count)
                }
            }
            if let artist = vm.artist {
                if !artist.albums.isEmpty {
                    SectionTitleView(LabelConstant.albums)
                        .padding(.leading, StyleConstant.Padding.large)
                    AlbumListView(albums: artist.albums, width: geometry.size.width)
                        .padding(.bottom, StyleConstant.Padding.large)
                }
                if !artist.songs.isEmpty {
                    SectionTitleView(LabelConstant.songs)
                        .padding(.leading, StyleConstant.Padding.large)
                    SongListView(songs: artist.songs) { playlistRegisterSongId = $0 }
                }
            }
        }
        .task {
            await vm.load(artistId: artistId).value
        }
    }
}
