//
//  ShortcutListView.swift
//  ThinMP
//
//  Created by tk on 2021/05/30.
//

import SwiftUI

/// ショートカットのグリッド。セルをタップで対象の詳細へ、長押しで解除(アーティストはお気に入りも)のメニューを出す
struct ShortcutListView: View {
    let shortcuts: [ShortcutModel]
    let width: CGFloat
    /// ショートカットの登録・解除後に呼ばれる(一覧の再読み込みなど)
    var callback: () -> Void = {}

    var body: some View {
        let layout = GridLayout(width: width)

        LazyVGrid(columns: layout.columns) {
            ForEach(shortcuts) { shortcut in
                switch shortcut.type {
                case .artist:
                    NavigationLink(destination: ArtistDetailPageView(artistId: shortcut.itemId.artistId)) {
                        ShortcutCellView(shortcut: shortcut, size: layout.cellSize)
                    }
                    .contentShape(RoundedRectangle(cornerRadius: StyleConstant.cornerRadius))
                    .contextMenu {
                        FavoriteArtistButtonView(artistId: shortcut.itemId.artistId)
                        ShortcutButtonView(itemId: shortcut.itemId.id, type: .artist, callback: callback)
                    }
                case .album:
                    NavigationLink(destination: AlbumDetailPageView(albumId: shortcut.itemId.albumId)) {
                        ShortcutCellView(shortcut: shortcut, size: layout.cellSize)
                    }
                    .contentShape(RoundedRectangle(cornerRadius: StyleConstant.cornerRadius))
                    .contextMenu {
                        ShortcutButtonView(itemId: shortcut.itemId.id, type: .album, callback: callback)
                    }
                case .playlist:
                    NavigationLink(destination: PlaylistDetailPageView(playlistId: shortcut.itemId.playlistId)) {
                        ShortcutCellView(shortcut: shortcut, size: layout.cellSize)
                    }
                    .contentShape(RoundedRectangle(cornerRadius: StyleConstant.cornerRadius))
                    .contextMenu {
                        ShortcutButtonView(itemId: shortcut.itemId.id, type: .playlist, callback: callback)
                    }
                }
            }
        }
    }
}
