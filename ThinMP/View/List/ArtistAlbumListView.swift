//
//  ArtistAlbumListView.swift
//  ThinMP
//
//  Created by tk on 2020/01/20.
//

import SwiftUI

struct ArtistAlbumListView: View {
    private let colCount = 2
    private let space: CGFloat = 20
    private var list: [AlbumModel]
    private var size: CGFloat
    private let columns:[GridItem]

    init(list: [AlbumModel], width: CGFloat) {
        self.list = list
        self.size = (width - (space * CGFloat(colCount + 1))) / CGFloat(colCount)
        self.columns = [
            GridItem(.fixed(size), spacing: space),
            GridItem(.fixed(size), spacing: 0),
        ]
    }

    var body: some View {
        LazyVGrid(columns: columns) {
            ForEach(list.indices, id: \.self) { index in
                NavigationLink(destination: AlbumDetailPageView(albumId: list[index].albumId)) {
                    ArtistAlbumCellView(album: list[index], size: size)
                }
            }
        }
    }
}
