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
    var list: [Album]
    var size: CGFloat
    
    init(list: [Album], width: CGFloat) {
        self.list = list
        self.size = (width - (space * CGFloat(colCount + 1))) / CGFloat(colCount)
    }

    var body: some View {
        LazyVGrid(columns: Array(repeating: GridItem(), count: colCount)) {
            ForEach(list.indices) { index in
                NavigationLink(destination: AlbumDetailPageView(persistentId: list[index].persistentID)) {
                    ArtistAlbumCellView(album: list[index], size: size)
                }
            }
        }
    }
}
