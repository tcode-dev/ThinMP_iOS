//
//  MainPageView.swift
//  ThinMP
//
//  Created by tk on 2020/01/04.
//

import SwiftUI

struct MainPageView: View {
    var body: some View {
        NavigationView {
            List {
                NavigationLink(destination: ArtistsPageView()) {
                    Text("Artists")
                }
                NavigationLink(destination: AlbumsPageView()) {
                    Text("Albums")
                }
                NavigationLink(destination: SongsPageView()) {
                    Text("Songs")
                }
                NavigationLink(destination: FavoriteArtistsPageView()) {
                    Text("FavoriteArtists")
                }
                NavigationLink(destination: FavoriteSongsPageView()) {
                    Text("FavoriteSongs")
                }
            }
            .listStyle(PlainListStyle())
            .navigationBarTitle("Library")
        }
    }
}
