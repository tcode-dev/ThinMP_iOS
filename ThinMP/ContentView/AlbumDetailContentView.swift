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
        ScrollView(showsIndicators: true) {
            VStack(alignment: .leading) {
                AlbumDetailHeaderView(albumDetail: albumDetail, rect: $rect)
                Text("\(self.rect.origin.y)")
                Text("\(self.offsetY)")
                ForEach(albumDetail.songs){ song in
                    SongRowView(song: song).padding(.bottom, 5)
                }.padding(.leading, 10)
            }
        }
        .navigationBarHidden(true)
        .navigationBarTitle(Text(""))
        .gesture(
            DragGesture()
                .onChanged{ value in
                    self.offsetY = self.rect.origin.y
            }
        )
    }
}
