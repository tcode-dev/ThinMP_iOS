//
//  MainMenuButtonView.swift
//  ThinMP
//
//  Created by tk on 2021/06/10.
//

import SwiftUI

/// メインページのライブラリメニュー 1 行。タップで対応する一覧ページへ
struct MainMenuButtonView: View {
    let menu: MainMenu

    var body: some View {
        NavigationLink(destination: destination) {
            MenuRowView(text: menu.label)
        }
    }

    @ViewBuilder
    private var destination: some View {
        switch menu {
        case .artists: ArtistsPageView()
        case .albums: AlbumsPageView()
        case .songs: SongsPageView()
        case .favoriteArtists: FavoriteArtistsPageView()
        case .favoriteSongs: FavoriteSongsPageView()
        case .playlists: PlaylistsPageView()
        }
    }
}
