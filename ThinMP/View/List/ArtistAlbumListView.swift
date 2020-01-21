//
//  ArtistAlbumListView.swift
//  ThinMP
//
//  Created by tk on 2020/01/20.
//

import SwiftUI

struct ArtistAlbumListView: View {
    let colCount = 2
    let space: CGFloat = 20
    var list: [[Album]]
    var size: CGFloat
    
    init(list: [Album], width: CGFloat) {
        self.list = list.chunked(into: colCount)
        self.size = (width - (space * CGFloat(colCount + 1))) / CGFloat(colCount)
    }

    var body: some View {
        ForEach(list.indices) { row in
            HStack(spacing: self.space) {
                ForEach(self.list[row].indices) { col in
                    NavigationLink(destination: AlbumDetailContentView(album: self.list[row][col])) {
                        ArtistAlbumCellView(album: self.list[row][col], size: self.size)
                    }
                }
            }
        }
    }
}
