//
//  ArtistDetailPageView.swift
//  ThinMP
//
//  Created by tk on 2020/01/07.
//

import SwiftUI

struct ArtistDetailPageView: View {
    @ObservedObject var artistDetail: ArtistDetailViewModel
    @State private var rect: CGRect = CGRect()
    
    init(artist: Artist) {
        self.artistDetail = ArtistDetailViewModel(persistentId: artist.persistentId)
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .top) {
                CustomNavigationBarView(primaryText: self.artistDetail.name, secondaryText: self.artistDetail.meta, side: geometry.size.width, rect: self.$rect)
                    .opacity(1)
                ScrollView{
                    ArtistDetailHeaderView(artistDetail: self.artistDetail, rect: self.$rect, side: geometry.size.width)
                    VStack(alignment: .leading) {
                        HeaderTextView("Albums")
                        ArtistAlbumListView(list: self.artistDetail.albums, width: geometry.size.width).padding(.bottom, 10)
                        
                        HeaderTextView("Songs")
                        ArtistSongListView(list: self.artistDetail.songs)
                    }
                    .frame(minWidth: geometry.size.width, maxWidth: .infinity, minHeight: geometry.size.height - 50, maxHeight: .infinity, alignment: .topLeading)
                    .padding(.leading, 20)
                }
                .navigationBarHidden(true)
                .navigationBarTitle(Text(""))
            }
            .edgesIgnoringSafeArea(.all)
        }
    }
}
