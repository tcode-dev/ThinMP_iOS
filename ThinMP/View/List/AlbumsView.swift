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
    var list: [[Album]]
    var size: CGFloat
    
    init(list: [Album], width: CGFloat) {
        self.list = list.chunked(into: colCount)
        self.size = (width - (space * CGFloat(colCount + 1))) / CGFloat(colCount)
    }
    
    var body: some View {
        List {
            ForEach(list.indices) { row in
                AlbumRowView(list: self.list[row], size: self.size, space: self.space)
            }
        }
    }
}
