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
                    ZStack(alignment: .bottom) {
                        Image(uiImage: self.albumDetail.artwork?.image(at: CGSize(width: geometry.size.width, height: geometry.size.width)) ?? UIImage())
                            .renderingMode(.original)
                            .resizable()
                            .aspectRatio(1, contentMode: .fit)
                        LinearGradient(gradient: Gradient(colors: [Color.init(Color.RGBColorSpace.sRGB, red: 1, green: 1, blue: 1, opacity: 0), .white]), startPoint: .top, endPoint: .bottom).frame(height: 200)
                        VStack {
                            PrimaryTextView(self.albumDetail.title)
                            SecondaryTextView(self.albumDetail.artist)
                        }
                    }
                    
                    ForEach(self.albumDetail.songs){ song in
                        SongRowView(song: song)
                    }
                }
            }
        }
    }
}
