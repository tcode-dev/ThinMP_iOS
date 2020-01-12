//
//  AlbumsView.swift
//  ThinMP
//
//  Created by tk on 2020/01/12.
//

import SwiftUI

struct AlbumsView: View {
    var list: [[Album]]
    init(list: [Album]) {
        self.list = list.chunked(into: 2)
    }
    var body: some View {
        ForEach(list.indices) { row in
            HStack {
                ForEach(self.list[row].indices) { col in
                    AlbumCellView(album: self.list[row][col])
                }
            }
        }
    }
}
