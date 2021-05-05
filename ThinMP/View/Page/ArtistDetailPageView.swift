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

    @ObservedObject var artistDetail: ArtistDetailViewModel

    @State private var textRect: CGRect = CGRect()
    @State private var isRegister: Bool = false
    @State private var showingPopup: Bool = false
    @State private var persistentID: MPMediaEntityPersistentID?

    init(artist: ArtistModel) {
        self.artistDetail = ArtistDetailViewModel(persistentId: artist.persistentId)
    }

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .top) {
                VStack(spacing: 0) {
                    ZStack(alignment: .top) {
                        DetaiNavBarView(primaryText: artistDetail.name, side: geometry.size.width, top: geometry.safeAreaInsets.top, textRect: self.$textRect) {
                            MenuButtonView {
                                FavoriteArtistButtonView(persistentId: artistDetail.persistentId)
                            }
                        }
                        ScrollView{
                            ArtistDetailHeaderView(artistDetail: artistDetail, textRect: $textRect, side: geometry.size.width, top: geometry.safeAreaInsets.top)
                            VStack(alignment: .leading) {
                                PrimaryTitleView("Albums")
                                    .padding(.leading, 20)
                                AlbumListView(list: self.artistDetail.albums, width: geometry.size.width)
                                    .padding(.bottom, 10)
                                PrimaryTitleView("Songs")
                                    .padding(.leading, 20)
                                LazyVStack() {
                                    ForEach(artistDetail.songs.indices){ index in
                                        PlayRowView(list: artistDetail.songs, index: index) {
                                            MediaRowView(media: artistDetail.songs[index])
                                        }
                                        .contextMenu {
                                            FavoriteSongButtonView(persistentId: artistDetail.songs[index].persistentID)
                                            Button(action: {
                                                persistentID = artistDetail.songs[index].persistentID
                                                showingPopup.toggle()
                                            }) {
                                                Text(ADD_TEXT)
                                            }
                                        }
                                        Divider()
                                    }.padding(.leading, 20)
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
