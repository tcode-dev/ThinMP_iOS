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
        GeometryReader { geometry in
            ScrollView {
                VStack(alignment: .leading) {
                    Image(uiImage: self.albumDetail.artwork?.image(at: CGSize(width: geometry.size.width, height: geometry.size.width)) ?? UIImage())
                        .renderingMode(.original)
                        .resizable()
                        .aspectRatio(1, contentMode: .fit)
                    
                    ForEach(self.albumDetail.songs){ song in
                        SongRowView(song: song)
                    }
                }
            }
        }
    }
}
