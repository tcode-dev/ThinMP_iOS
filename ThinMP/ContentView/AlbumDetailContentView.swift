//
//  AlbumDetailContentView.swift
//  ThinMP
//
//  Created by tk on 2020/01/12.
//

import SwiftUI

struct AlbumDetailContentView: View {
    @ObservedObject var albumDetail: AlbumDetailViewModel
    
    init(album: Album) {
        self.albumDetail = AlbumDetailViewModel(persistentId: album.persistentID)
    }
    
    var body: some View {
        ScrollView(showsIndicators: true) {
            VStack(alignment: .leading) {
                AlbumDetailHeaderView(albumDetail: albumDetail)
                ForEach(albumDetail.songs){ song in
                    SongRowView(song: song).padding(.bottom, 5)
                }.padding(.leading, 10)
            }
        }
        .navigationBarHidden(true)
        .navigationBarTitle(Text(""))
    }
}
