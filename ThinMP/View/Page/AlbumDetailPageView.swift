//
//  AlbumDetailPageView.swift
//  ThinMP
//
//  Created by tk on 2020/01/12.
//

import SwiftUI
import MediaPlayer

struct AlbumDetailPageView: View {
    @ObservedObject var albumDetail: AlbumDetailViewModel
    @State private var rect: CGRect = CGRect()
    
    init(persistentId: MPMediaEntityPersistentID) {
        self.albumDetail = AlbumDetailViewModel(persistentId: persistentId)
    }
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                ZStack(alignment: .top) {
                    CustomNavigationBarView(primaryText: self.albumDetail.title, secondaryText: self.albumDetail.artist, side: geometry.size.width, pageRect: self.$rect)
                    ScrollView(showsIndicators: true) {
                        VStack(alignment: .leading) {
                            AlbumDetailHeaderView(albumDetail: self.albumDetail, rect: self.$rect, side: geometry.size.width)
                            VStack{
                                ForEach(self.albumDetail.songs.indices){ index in
                                    AlbumSongRowView(list: self.albumDetail.songs, index: index)
                                    Divider()
                                }.padding(.leading, 10)
                            }
                            .frame(minWidth: geometry.size.width, maxWidth: .infinity, minHeight: geometry.size.height - 50, maxHeight: .infinity, alignment: .topLeading)
                        }
                    }
                    .navigationBarHidden(true)
                    .navigationBarTitle(Text(""))
                }
                MiniPlayerView()
            }
            .edgesIgnoringSafeArea(.all)
        }
    }
}
