//
//  AlbumListView.swift
//  ThinMP
//
//  Created by tk on 2021/05/30.
//

import SwiftUI

/// アルバムのグリッド。セルをタップで詳細へ、長押しでショートカットのメニューを出す
struct AlbumListView: View {
    let albums: [AlbumModel]
    let width: CGFloat
    /// ショートカットの登録・解除後に呼ばれる(一覧の再読み込みなど)
    var callback: () -> Void = {}

    var body: some View {
        let layout = GridLayout(width: width)

        LazyVGrid(columns: layout.columns) {
            ForEach(albums) { album in
                NavigationLink(destination: AlbumDetailPageView(albumId: album.albumId)) {
                    AlbumCellView(album: album, size: layout.cellSize)
                }
                .contentShape(RoundedRectangle(cornerRadius: StyleConstant.cornerRadius))
                .contextMenu {
                    ShortcutButtonView(target: .album(album.albumId), callback: callback)
                }
            }
        }
    }
}
