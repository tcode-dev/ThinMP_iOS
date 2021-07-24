//
//  AlbumListView.swift
//  ThinMP
//
//  Created by tk on 2021/05/30.
//

import SwiftUI

struct AlbumListView: View {
    private let colCount = 2
    private let albums: [AlbumModel]
    private let size: CGFloat
    private let columns: [GridItem]
    private let callback: () -> Void

    init(albums: [AlbumModel], width: CGFloat, callback: @escaping () -> Void = {}) {
        self.albums = albums
        self.callback = callback
        size = (width - (StyleConstant.Padding.large * CGFloat(colCount + 1))) / CGFloat(colCount)
        columns = [
            GridItem(.fixed(size), spacing: StyleConstant.Padding.large),
            GridItem(.fixed(size), spacing: 0),
        ]
    }

    var body: some View {
        LazyVGrid(columns: columns) {
            ForEach(albums) { album in
                NavigationLink(destination: AlbumDetailPageView(albumId: album.albumId)) {
                    AlbumCellView(album: album, size: size)
                }
                .contentShape(RoundedRectangle(cornerRadius: StyleConstant.cornerRadius))
                .contextMenu {
                    ShortcutButtonView(itemId: album.id, type: ShortcutType.ALBUM, callback: callback)
                }
            }
        }
    }
}
