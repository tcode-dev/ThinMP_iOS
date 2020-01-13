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
            Image(uiImage: self.album.artwork?.image(at: cgSize) ?? UIImage())
                .renderingMode(.original)
                .resizable()
                .aspectRatio(1, contentMode: .fit)
            
            Text(self.album.title ?? "unknown").foregroundColor(.primary).lineLimit(1)

            Text(self.album.artist ?? "unknown").foregroundColor(.secondary).lineLimit(1)
        }.frame(width: width)
    }
}
