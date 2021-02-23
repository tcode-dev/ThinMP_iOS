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
                CustomNavBarView(persistentId: self.artistDetail.persistentId, primaryText: self.artistDetail.name, secondaryText: self.artistDetail.meta, side: geometry.size.width, top: geometry.safeAreaInsets.top, textRect: self.$textRect)
                ScrollView{
                    ArtistDetailHeaderView(artistDetail: self.artistDetail, textRect: self.$textRect, side: geometry.size.width, top: geometry.safeAreaInsets.top)
                    VStack(alignment: .leading) {
                        PrimaryTitleView("Albums")
                            .padding(.leading, 20)
                        ArtistAlbumListView(list: self.artistDetail.albums, width: geometry.size.width)
                            .padding(.bottom, 10)

                        PrimaryTitleView("Songs")
                            .padding(.leading, 20)
                        ForEach(self.artistDetail.songs.indices){ index in
                            ArtistSongRowView(list: self.artistDetail.songs, index: index)
                            Divider()
                        }.padding(.leading, 20)
                    }
                }
                .navigationBarHidden(true)
                .navigationBarTitle(Text(""))
            }
            .edgesIgnoringSafeArea(.all)
        }
    }
}
