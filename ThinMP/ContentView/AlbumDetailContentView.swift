//
//  AlbumDetailContentView.swift
//  ThinMP
//
//  Created by tk on 2020/01/12.
//

import SwiftUI

struct AlbumDetailContentView: View {
    @ObservedObject var albumDetail: AlbumDetailViewModel
    @State private var rect: CGRect = CGRect()
    
    init(album: Album) {
        self.albumDetail = AlbumDetailViewModel(persistentId: album.persistentID)
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .top) {
                CustomNavigationBarView(primaryText: self.albumDetail.title, secondaryText: self.albumDetail.artist, side: geometry.size.width, rect: self.$rect)

                ScrollView(showsIndicators: true) {
                    VStack(alignment: .leading) {
                        AlbumDetailHeaderView(albumDetail: self.albumDetail, rect: self.$rect, side: geometry.size.width)
                        VStack{
                            ForEach(self.albumDetail.songs){ song in
                                AlbumSongRowView(song: song)
                                Divider()
                            }.padding(.leading, 10)
                        }
                        .frame(minWidth: geometry.size.width, maxWidth: .infinity, minHeight: geometry.size.height - 50, maxHeight: .infinity, alignment: .topLeading)
                    }
                }
                .navigationBarHidden(true)
                .navigationBarTitle(Text(""))
            }
            .edgesIgnoringSafeArea(.all)
        }
    }
}
