//
//  ArtistDetailPageView.swift
//  ThinMP
//
//  Created by tk on 2020/01/07.
//

import SwiftUI

struct ArtistDetailPageView: View {
    @ObservedObject var artistDetail: ArtistDetailViewModel
    @State private var pageRect: CGRect = CGRect()
    @State private var headerRect: CGRect = CGRect()

    init(artist: Artist) {
        self.artistDetail = ArtistDetailViewModel(persistentId: artist.persistentId)
    }

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .top) {
                CustomNavigationBarView(primaryText: self.artistDetail.name, secondaryText: self.artistDetail.meta, side: geometry.size.width, pageRect: self.$pageRect, headerRect: self.$headerRect)
                    .opacity(1)
                ScrollView{
                    ArtistDetailHeaderView(artistDetail: self.artistDetail, rect: self.$pageRect, side: geometry.size.width)
                    VStack(alignment: .leading) {
                        HeaderTextView("Albums")
                            .padding(.leading, 20)
                        ArtistAlbumListView(list: self.artistDetail.albums, width: geometry.size.width)
                            .padding(.bottom, 10)

                        HeaderTextView("Songs")
                            .padding(.leading, 20)
                        ArtistSongListView(list: self.artistDetail.songs)
                            .padding(.leading, 20)
                    }
                }
                .navigationBarHidden(true)
                .navigationBarTitle(Text(""))
            }
            .edgesIgnoringSafeArea(.all)
        }
    }
}
