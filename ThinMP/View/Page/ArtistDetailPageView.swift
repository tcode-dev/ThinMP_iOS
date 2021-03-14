//
//  ArtistDetailPageView.swift
//  ThinMP
//
//  Created by tk on 2020/01/07.
//

import SwiftUI

struct ArtistDetailPageView: View {
    @ObservedObject var artistDetail: ArtistDetailViewModel
    @State private var textRect: CGRect = CGRect()

    init(artist: Artist) {
        self.artistDetail = ArtistDetailViewModel(persistentId: artist.persistentId)
    }

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .top) {
                DetaiNavBarView(primaryText: self.artistDetail.name, side: geometry.size.width, top: geometry.safeAreaInsets.top, textRect: self.$textRect) {
                    MenuButtonView {
                        FavoriteArtistButtonView(persistentId: self.artistDetail.persistentId)
                    }
                }
                ScrollView{
                    ArtistDetailHeaderView(artistDetail: self.artistDetail, textRect: self.$textRect, side: geometry.size.width, top: geometry.safeAreaInsets.top)
                    VStack(alignment: .leading) {
                        PrimaryTitleView("Albums")
                            .padding(.leading, 20)
                        ArtistAlbumListView(list: self.artistDetail.albums, width: geometry.size.width)
                            .padding(.bottom, 10)

                        PrimaryTitleView("Songs")
                            .padding(.leading, 20)
                        LazyVGrid(columns: [GridItem()]) {
                            ForEach(self.artistDetail.songs.indices){ index in
                                ArtistSongRowView(list: self.artistDetail.songs, index: index)
                                Divider()
                            }.padding(.leading, 20)
                        }
                    }
                }
                .navigationBarHidden(true)
                .navigationBarTitle(Text(""))
            }
            .edgesIgnoringSafeArea(.all)
        }
    }
}
