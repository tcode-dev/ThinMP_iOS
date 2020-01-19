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
    @State private var offsetY: CGFloat = 0
    
    init(album: Album) {
        self.albumDetail = AlbumDetailViewModel(persistentId: album.persistentID)
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .top) {
                CustomNavigationBarView(primaryText: self.albumDetail.title, secondaryText: self.albumDetail.artist, end: geometry.size.width, rect: self.$rect).zIndex(1)
                ScrollView(showsIndicators: true) {
                    VStack(alignment: .leading) {
                        AlbumDetailHeaderView(albumDetail: self.albumDetail, rect: self.$rect)
                        VStack{
                            ForEach(self.albumDetail.songs){ song in
                                AlbumSongRowView(song: song)
                                Divider()
                            }.padding(.leading, 10)
                        }
                        .frame(minWidth: geometry.size.width, maxWidth: .infinity, minHeight: geometry.size.height - 70, maxHeight: .infinity, alignment: .topLeading)
                    }
                }
                .navigationBarHidden(true)
                .navigationBarTitle(Text(""))
                .edgesIgnoringSafeArea([.top, .bottom])
            }
        }
    }
}
