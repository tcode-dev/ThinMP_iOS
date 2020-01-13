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
        VStack{
            Image(uiImage: self.album.artwork?.image(at: cgSize) ?? UIImage())
                .resizable()
                .aspectRatio(1, contentMode: .fit)
            Text(self.album.title ?? "unknown").lineLimit(1)
        }.frame(width: width)
    }
}
