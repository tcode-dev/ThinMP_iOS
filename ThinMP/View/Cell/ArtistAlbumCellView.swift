//
//  ArtistAlbumCell.swift
//  ThinMP
//
//  Created by tk on 2020/01/20.
//

import SwiftUI

struct ArtistAlbumCellView: View {
    var album: Album
    var width: CGFloat
    var cgSize: CGSize
    
    var body: some View {
        VStack(){
            Image(uiImage: self.album.artwork?.image(at: cgSize) ?? UIImage())
                .renderingMode(.original)
                .resizable()
                .aspectRatio(1, contentMode: .fit)
                .cornerRadius(4)
                .overlay(RoundedRectangle(cornerRadius: 4)
                    .stroke(Color("#f2f2f2"), lineWidth: 1))
            
            PrimaryTextView(self.album.title)
        }.frame(width: width)
    }
}
