//
//  AlbumListView.swift
//  ThinMP
//
//  Created by tk on 2021/05/30.
//

import SwiftUI

struct AlbumListView: View {
    private let colCount = 2
    private let list: [AlbumModel]
    private let size: CGFloat
    private let columns: [GridItem]

    init(list: [AlbumModel], width: CGFloat) {
        self.list = list
        self.size = (width - (StyleConstant.padding.large * CGFloat(colCount + 1))) / CGFloat(colCount)
        self.columns = [
            GridItem(.fixed(size), spacing: StyleConstant.padding.large),
            GridItem(.fixed(size), spacing: 0)
        ]
    }

    var body: some View {
        LazyVGrid(columns: columns) {
            ForEach(list.indices, id: \.self) { index in
                NavigationLink(destination: AlbumDetailPageView(albumId: list[index].albumId)) {
                    AlbumCellView(album: list[index], size: size)
                }
            }
        }
    }
}
