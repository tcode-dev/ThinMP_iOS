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
                    MenuRowView(text: menu.primaryText!)
                }
            case LabelConstant.albums:
                NavigationLink(destination: AlbumsPageView()) {
                    MenuRowView(text: menu.primaryText!)
                }
            case LabelConstant.songs:
                NavigationLink(destination: SongsPageView()) {
                    MenuRowView(text: menu.primaryText!)
                }
            case LabelConstant.favoriteArtists:
                NavigationLink(destination: FavoriteArtistsPageView()) {
                    MenuRowView(text: menu.primaryText!)
                }
            case LabelConstant.favoriteSongs:
                NavigationLink(destination: FavoriteSongsPageView()) {
                    MenuRowView(text: menu.primaryText!)
                }
            case LabelConstant.playlists:
                NavigationLink(destination: PlaylistsPageView()) {
                    MenuRowView(text: menu.primaryText!)
                }
            default:
                EmptyView()
            }
        }
    }
}
