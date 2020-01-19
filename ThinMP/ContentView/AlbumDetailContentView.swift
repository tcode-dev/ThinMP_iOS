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
        ZStack(alignment: .top) {
            CustomNavigationBarView(primaryText: albumDetail.title, secondaryText: albumDetail.artist, end: rect.size.width, rect: $rect).zIndex(1)
            ScrollView(showsIndicators: true) {
                VStack(alignment: .leading) {
                    AlbumDetailHeaderView(albumDetail: albumDetail, rect: $rect)
                    VStack{
                        ForEach(albumDetail.songs){ song in
                            SongRowView(song: song)
                            Divider()
                        }.padding(.leading, 10)
                    }
                    .frame(minWidth: UIScreen.main.bounds.size.width, maxWidth: .infinity, minHeight: UIScreen.main.bounds.size.height - 70, maxHeight: .infinity, alignment: .topLeading)
                }
            }
            .navigationBarHidden(true)
            .navigationBarTitle(Text(""))
            .edgesIgnoringSafeArea([.top, .bottom])
        }
    }
}
