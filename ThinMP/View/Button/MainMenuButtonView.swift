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
                    PlainRowView(media: menu)
                }
            case LabelConstant.albums:
                NavigationLink(destination: AlbumsPageView()) {
                    PlainRowView(media: menu)
                }
            case LabelConstant.songs:
                NavigationLink(destination: SongsPageView()) {
                    PlainRowView(media: menu)
                }
            case LabelConstant.favoriteArtists:
                NavigationLink(destination: FavoriteArtistsPageView()) {
                    PlainRowView(media: menu)
                }
            case LabelConstant.favoriteSongs:
                NavigationLink(destination: FavoriteSongsPageView()) {
                    PlainRowView(media: menu)
                }
            case LabelConstant.playlists:
                NavigationLink(destination: PlaylistsPageView()) {
                    PlainRowView(media: menu)
                }
            default:
                EmptyView()
            }
        }
    }
}
