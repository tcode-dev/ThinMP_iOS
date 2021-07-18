//
//  ArtistAlbumListView.swift
//  ThinMP
//
//  Created by tk on 2020/01/20.
//

import SwiftUI

struct ArtistAlbumListView: View {
    private let colCount = 2
    private var list: [AlbumModel]
    private var size: CGFloat
    private let columns: [GridItem]

    init(list: [AlbumModel], width: CGFloat) {
        self.list = list
        size = (width - (StyleConstant.Padding.large * CGFloat(colCount + 1))) / CGFloat(colCount)
        columns = [
            GridItem(.fixed(size), spacing: StyleConstant.Padding.large),
            GridItem(.fixed(size), spacing: 0),
        ]
    }

    var body: some View {
        LazyVGrid(columns: columns) {
            ForEach(list.indices, id: \.self) { index in
                NavigationLink(destination: AlbumDetailPageView(albumId: list[index].albumId)) {
                    ArtistAlbumCellView(album: list[index], size: size)
                        .contextMenu {
                            ShortcutButtonView(itemId: list[index].id, type: ShortcutType.ALBUM)
                        }
                }
            }
        }
    }
}
