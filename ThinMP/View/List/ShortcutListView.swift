//
//  ShortcutListView.swift
//  ThinMP
//
//  Created by tk on 2021/05/30.
//

import SwiftUI

struct ShortcutListView: View {
    private let colCount: Int
    private let shortcuts: [ShortcutModel]
    private let size: CGFloat
    private let columns: [GridItem]
    private let callback: () -> Void

    init(shortcuts: [ShortcutModel], width: CGFloat, callback: @escaping () -> Void = {}) {
        self.shortcuts = shortcuts
        self.callback = callback
        self.colCount = max(Int(width) / StyleConstant.Grid.spanBaseSize, StyleConstant.Grid.minSpanCount)

        size = (width - (StyleConstant.Padding.large * CGFloat(colCount + 1))) / CGFloat(colCount)

        var columns = [GridItem](repeating: GridItem(.fixed(size), spacing: StyleConstant.Padding.large), count: Int(colCount) - 1)

        columns.append((GridItem(.fixed(size), spacing: 0)))

        self.columns = columns
    }

    var body: some View {
        LazyVGrid(columns: columns) {
            ForEach(shortcuts) { shortcut in
                switch shortcut.type {
                case .artist:
                    NavigationLink(destination: ArtistDetailPageView(artistId: shortcut.itemId.artistId)) {
                        ShortcutCellView(shortcut: shortcut, size: size)
                    }
                    .contentShape(RoundedRectangle(cornerRadius: StyleConstant.cornerRadius))
                    .contextMenu {
                        FavoriteArtistButtonView(artistId: shortcut.itemId.artistId)
                        ShortcutButtonView(itemId: shortcut.itemId.id, type: .artist, callback: callback)
                    }
                case .album:
                    NavigationLink(destination: AlbumDetailPageView(albumId: shortcut.itemId.albumId)) {
                        ShortcutCellView(shortcut: shortcut, size: size)
                    }
                    .contentShape(RoundedRectangle(cornerRadius: StyleConstant.cornerRadius))
                    .contextMenu {
                        ShortcutButtonView(itemId: shortcut.itemId.id, type: .album, callback: callback)
                    }
                case .playlist:
                    NavigationLink(destination: PlaylistDetailPageView(playlistId: shortcut.itemId.playlistId)) {
                        ShortcutCellView(shortcut: shortcut, size: size)
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
