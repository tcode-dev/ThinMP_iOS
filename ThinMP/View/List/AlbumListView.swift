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
    private let callback: () -> Void

    init(list: [AlbumModel], width: CGFloat, callback: @escaping () -> Void = {}) {
        self.list = list
        self.callback = callback
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
                    AlbumCellView(album: list[index], size: size)
                }
                .contentShape(RoundedRectangle(cornerRadius: StyleConstant.cornerRadius))
                .contextMenu {
                    ShortcutButtonView(itemId: list[index].id, type: ShortcutType.ALBUM, callback: callback)
                }
            }
        }
    }
}
