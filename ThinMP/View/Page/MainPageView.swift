//
//  MainPageView.swift
//  ThinMP
//
//  Created by tk on 2020/01/04.
//

import SwiftUI

struct MainPageView: View {
    private let LIBRARY: String = "Library"
    private let ARTISTS: String = "Artists"
    private let ALBUMS: String = "Albums"
    private let SONGS: String = "Songs"
    private let FAVORITE_ARTISTS: String = "Favorite Artists"
    private let FAVORITE_SONGS: String = "Favorite Songs"
    private let PLAYLISTS: String = "Playlists"
    private let RECENTLY_ADDED: String = "Recently Added"
    private let SHORTCUTS: String = "Shortcuts"

    private var HEADER_HEIGHT: CGFloat = 90
    private var ROW_HEIGHT: CGFloat = 44

    @StateObject private var vm = MainViewModel()

    var body: some View {
        GeometryReader { geometry in
            NavigationView {
                VStack(spacing: 0) {
                    ScrollView {
                        VStack(alignment: .leading) {
                            Spacer()
                            Text(LIBRARY).fontWeight(.bold).font(.largeTitle)
                            Divider()
                        }
                        .frame(height: geometry.safeAreaInsets.top + HEADER_HEIGHT)
                        .padding(.leading, 20)
                        VStack {
                            VStack {
                                NavigationLink(destination: ArtistsPageView()) {
                                    MediaRowView(media: MenuModel(primaryText: ARTISTS))
                                }
                                Divider()
                            }
                            VStack {
                                NavigationLink(destination: AlbumsPageView()) {
                                    MediaRowView(media: MenuModel(primaryText: ALBUMS))
                                }
                                Divider()
                            }
                            VStack {
                                NavigationLink(destination: SongsPageView()) {
                                    MediaRowView(media: MenuModel(primaryText: SONGS))
                                }
                                Divider()
                            }
                            VStack {
                                NavigationLink(destination: FavoriteArtistsPageView()) {
                                    MediaRowView(media: MenuModel(primaryText: FAVORITE_ARTISTS))
                                }
                                Divider()
                            }
                            VStack {
                                NavigationLink(destination: FavoriteSongsPageView()) {
                                    MediaRowView(media: MenuModel(primaryText: FAVORITE_SONGS))
                                }
                                Divider()
                            }
                            VStack {
                                NavigationLink(destination: PlaylistsPageView()) {
                                    MediaRowView(media: MenuModel(primaryText: PLAYLISTS))
                                }
                                Divider()
                            }
                        }
                        .padding(.leading, 20)
                        .padding(.bottom, 20)
                        VStack(alignment: .leading) {
                            PrimaryTitleView(SHORTCUTS)
                                .padding(.leading, 20)
                            ShortcutListView(list: vm.shortcuts, width: geometry.size.width)
                                .padding(.bottom, 10)
                        }
                        VStack(alignment: .leading) {
                            PrimaryTitleView(RECENTLY_ADDED)
                                .padding(.leading, 20)
                            AlbumListView(list: vm.albums, width: geometry.size.width)
                                .padding(.bottom, 10)
                        }
                    }
                    MiniPlayerView(bottom: geometry.safeAreaInsets.bottom)
                }
                .navigationBarHidden(true)
                .navigationBarTitle(Text(""))
                .edgesIgnoringSafeArea(.all)
                .onAppear() {
                    vm.load()
                }
            }
        }
    }
}
