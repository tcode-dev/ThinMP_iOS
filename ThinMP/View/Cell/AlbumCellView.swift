//
//  AlbumCellView.swift
//  ThinMP
//
//  Created by tk on 2020/01/12.
//

import SwiftUI

struct AlbumCellView: View {
    var album: AlbumModel
    var size: CGFloat
    
    var body: some View {
        VStack(){
            SquareImageView(artwork: self.album.artwork, size: size)
            PrimaryTextView(self.album.title)
            SecondaryTextView(self.album.artist)
        }
    }
}
