//
//  ArtistDetailContentView.swift
//  ThinMP
//
//  Created by tk on 2020/01/07.
//

import SwiftUI

struct ArtistDetailContentView: View {
    @ObservedObject var artistDetail: ArtistDetailViewModel
    var artistImageSize:CGFloat = 120
    
    init(artist: Artist) {
        self.artistDetail = ArtistDetailViewModel(persistentId: artist.persistentId)
    }
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView{
                ZStack(alignment: .bottom) {
                    Image(uiImage: self.artistDetail.artwork?.image(at: CGSize(width: geometry.size.width, height: geometry.size.width)) ?? UIImage())
                        .resizable()
                        .aspectRatio(1, contentMode: .fit)
                        .blur(radius: 10.0)
                    
                    LinearGradient(gradient: Gradient(colors: [Color.init(Color.RGBColorSpace.sRGB, red: 1, green: 1, blue: 1, opacity: 0), .white]), startPoint: .top, endPoint: .bottom).frame(height: 355).offset(y: 25)
                    CircleImageView(artwork: self.artistDetail.artwork, size: self.artistImageSize)
                        .offset(y:-100)

                    VStack {
                        HeaderTextView(self.artistDetail.name)
                        SecondaryTextView("\(self.artistDetail.albumCount) albums, \(self.artistDetail.songCount) songs")
                    }
                }
                
                VStack(alignment: .leading) {
                    HeaderTextView("Albums")
                    ArtistAlbumListView(list: self.artistDetail.albums, width: geometry.size.width).padding(.bottom, 10)
                    
                    HeaderTextView("Songs")
                    ArtistSongListView(list: self.artistDetail.songs)
                }.frame(maxWidth: .infinity, alignment: .leading).padding(.leading, 20)
            }
            .navigationBarHidden(true)
            .navigationBarTitle(Text(""))
        }
    }
}
