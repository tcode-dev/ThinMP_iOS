//
//  AlbumCellView.swift
//  ThinMP
//
//  Created by tk on 2020/01/12.
//

import SwiftUI

struct AlbumCellView: View {
    var album: Album
    var width: CGFloat
    var cgSize: CGSize
    
    var body: some View {
        VStack(){
            SquareImageView(artwork: self.album.artwork, cgSize: cgSize)
            PrimaryTextView(self.album.title)
            SecondaryTextView(self.album.artist)
        }.frame(width: width)
    }
}
