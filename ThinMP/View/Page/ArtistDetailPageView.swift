//
//  ArtistDetailPageView.swift
//  ThinMP
//
//  Created by tk on 2020/01/07.
//

import SwiftUI
import MediaPlayer

struct ArtistDetailPageView: View {
    private let ADD_TEXT: String = "プレイリストに追加"
    private let ALBUMS: String = "Albums"
    private let SONGS: String = "Songs"
    private let LEADING: CGFloat = 20
    private let BOTTOM: CGFloat = 20

    @ObservedObject var artistDetail: ArtistDetailViewModel

    @State private var textRect: CGRect = CGRect()
    @State private var isRegister: Bool = false
    @State private var showingPopup: Bool = false
    @State private var persistentID: MPMediaEntityPersistentID?

    init(persistentId: MPMediaEntityPersistentID) {
        self.artistDetail = ArtistDetailViewModel(persistentId: persistentId)
    }

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .top) {
                VStack(spacing: 0) {
                    ZStack(alignment: .top) {
                        DetaiNavBarView(primaryText: artistDetail.name, side: geometry.size.width, top: geometry.safeAreaInsets.top, textRect: self.$textRect) {
                            MenuButtonView {
                                VStack {
                                    FavoriteArtistButtonView(persistentId: artistDetail.persistentId)
                                    ShortcutButtonView(itemId: artistDetail.persistentId, type: ShortcutType.ARTIST)
                                }
                            }
                        }
                        ScrollView{
                            ArtistDetailHeaderView(artistDetail: artistDetail, textRect: $textRect, side: geometry.size.width, top: geometry.safeAreaInsets.top)
                            VStack(alignment: .leading) {
                                PrimaryTitleView(ALBUMS)
                                    .padding(.leading, LEADING)
                                ArtistAlbumListView(list: self.artistDetail.albums, width: geometry.size.width)
                                    .padding(.bottom, BOTTOM)
                                PrimaryTitleView(SONGS)
                                    .padding(.leading, LEADING)
                                LazyVStack() {
                                    ForEach(artistDetail.songs.indices){ index in
                                        PlayRowView(list: artistDetail.songs, index: index) {
                                            MediaRowView(media: artistDetail.songs[index])
                                        }
                                        .contextMenu {
                                            FavoriteSongButtonView(persistentId: artistDetail.songs[index].persistentId)
                                            Button(action: {
                                                persistentID = artistDetail.songs[index].persistentId
                                                showingPopup.toggle()
                                            }) {
                                                Text(ADD_TEXT)
                                            }
                                        }
                                        Divider()
                                    }.padding(.leading, LEADING)
                                }
                            }
                        }
                    }
                    MiniPlayerView(bottom: geometry.safeAreaInsets.bottom)
                }
                if (showingPopup) {
                    PopupView(showingPopup: $showingPopup) {
                        PlaylistRegisterView(persistentId: persistentID!, showingPopup: $showingPopup, height: geometry.size.height)
                    }
                }
            }
            .navigationBarHidden(true)
            .navigationBarTitle(Text(""))
            .edgesIgnoringSafeArea(.all)
        }
    }
}
