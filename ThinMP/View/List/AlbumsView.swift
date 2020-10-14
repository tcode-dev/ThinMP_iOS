//
//  AlbumsView.swift
//  ThinMP
//
//  Created by tk on 2020/01/12.
//

import SwiftUI

struct AlbumsView: View {
    let colCount = 2
    let space: CGFloat = 20
    var list: [Album]
    var size: CGFloat

    init(list: [Album], width: CGFloat) {
        self.list = list
        self.size = (width - (space * CGFloat(colCount + 1))) / CGFloat(colCount)
    }

    var body: some View {
        ScrollView {
            LazyVGrid(columns: Array(repeating: GridItem(), count: 2)) { // カラム数の指定
                ForEach(self.list.indices) { index in
                    AlbumCellView(album: self.list[index], size: self.size)
                }
            }
        }
    }
}
