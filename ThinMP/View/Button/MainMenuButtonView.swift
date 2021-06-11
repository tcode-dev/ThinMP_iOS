//
//  MainMenuButtonView.swift
//  ThinMP
//
//  Created by tk on 2021/06/10.
//

import SwiftUI

struct MainMenuButtonView: View {
    let type: String

    var body: some View {
        Group {
            switch type {
            case LabelConstant.artists:
                NavigationLink(destination: ArtistsPageView()) {
                    MediaRowView(media: MenuModel(primaryText: LabelConstant.artists))
                }
            case LabelConstant.albums:
                NavigationLink(destination: AlbumsPageView()) {
                    MediaRowView(media: MenuModel(primaryText: LabelConstant.albums))
                }
            case LabelConstant.songs:
                NavigationLink(destination: SongsPageView()) {
                    MediaRowView(media: MenuModel(primaryText: LabelConstant.songs))
                }
            case LabelConstant.favoriteArtists:
                NavigationLink(destination: FavoriteArtistsPageView()) {
                    MediaRowView(media: MenuModel(primaryText: LabelConstant.favoriteArtists))
                }
            case LabelConstant.favoriteSongs:
                NavigationLink(destination: FavoriteSongsPageView()) {
                    MediaRowView(media: MenuModel(primaryText: LabelConstant.favoriteSongs))
                }
            case LabelConstant.playlists:
                NavigationLink(destination: PlaylistsPageView()) {
                    MediaRowView(media: MenuModel(primaryText: LabelConstant.playlists))
                }
            default:
                EmptyView()
            }
        }
    }
}
