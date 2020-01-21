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
            SquareImageView(artwork: self.album.artwork, cgSize: cgSize)
            PrimaryTextView(self.album.title)
        }.frame(width: width)
    }
}
