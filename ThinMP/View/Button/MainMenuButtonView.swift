//
//  MainMenuButtonView.swift
//  ThinMP
//
//  Created by tk on 2021/06/10.
//

import SwiftUI

struct MainMenuButtonView: View {
    let menu: MenuModel

    var body: some View {
        Group {
            switch menu.primaryText {
            case LabelConstant.artists:
                NavigationLink(destination: ArtistsPageView()) {
                    MediaRowView(media: menu)
                }
            case LabelConstant.albums:
                NavigationLink(destination: AlbumsPageView()) {
                    MediaRowView(media: menu)
                }
            case LabelConstant.songs:
                NavigationLink(destination: SongsPageView()) {
                    MediaRowView(media: menu)
                }
            case LabelConstant.favoriteArtists:
                NavigationLink(destination: FavoriteArtistsPageView()) {
                    MediaRowView(media: menu)
                }
            case LabelConstant.favoriteSongs:
                NavigationLink(destination: FavoriteSongsPageView()) {
                    MediaRowView(media: menu)
                }
            case LabelConstant.playlists:
                NavigationLink(destination: PlaylistsPageView()) {
                    MediaRowView(media: menu)
                }
            default:
                EmptyView()
            }
        }
    }
}
