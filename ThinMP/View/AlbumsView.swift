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
    var width: CGFloat
    var cgSize: CGSize
    
    init(list: [Album], width: CGFloat) {
        self.list = list.chunked(into: colCount)
        self.width = (width - (space * CGFloat(colCount + 1))) / CGFloat(colCount)
        self.cgSize = CGSize(width: self.width, height: self.width)
    }
    var body: some View {
        ForEach(list.indices) { row in
            HStack(spacing: self.space) {
                ForEach(self.list[row].indices) { col in
                    NavigationLink(destination: AlbumDetailContentView(album: self.list[row][col])) {
                        AlbumCellView(album: self.list[row][col], width: self.width, cgSize: self.cgSize)
                    }
                }
            }
        }
    }
}
