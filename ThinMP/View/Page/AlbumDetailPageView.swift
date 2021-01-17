//
//  AlbumDetailPageView.swift
//  ThinMP
//
//  Created by tk on 2020/01/12.
//

import SwiftUI
import MediaPlayer

struct AlbumDetailPageView: View {
    @EnvironmentObject var musicPlayer: MusicPlayer
    @ObservedObject var albumDetail: AlbumDetailViewModel
    @State private var pageRect: CGRect = CGRect()
    @State private var headerRect: CGRect = CGRect()
    let barHeight: CGFloat = 50
    
    init(persistentId: MPMediaEntityPersistentID) {
        self.albumDetail = AlbumDetailViewModel(persistentId: persistentId)
    }
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                ZStack(alignment: .top) {
                    CustomNavigationBarView(persistentId: self.albumDetail.persistentId, primaryText: self.albumDetail.title, secondaryText: self.albumDetail.artist, side: geometry.size.width, top: geometry.safeAreaInsets.top, pageRect: self.$pageRect, headerRect: self.$headerRect)
                    ScrollView(showsIndicators: true) {
                        VStack(alignment: .leading) {
                            AlbumDetailHeaderView(albumDetail: self.albumDetail, rect: self.$pageRect, side: geometry.size.width)
                            VStack{
                                ForEach(self.albumDetail.songs.indices){ index in
                                    AlbumSongRowView(list: self.albumDetail.songs, index: index)
                                    Divider()
                                }.padding(.leading, 10)
                            }
                        }
                    }
                    .navigationBarHidden(true)
                    .navigationBarTitle(Text(""))
                }
                MiniPlayerView(bottom: geometry.safeAreaInsets.bottom)
            }
            .edgesIgnoringSafeArea(.all)
        }
    }
}
