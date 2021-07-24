//
//  ShortcutListView.swift
//  ThinMP
//
//  Created by tk on 2021/05/30.
//

import MediaPlayer
import SwiftUI

struct ShortcutListView: View {
    private let colCount = 2
    private let shortcuts: [ShortcutModel]
    private let size: CGFloat
    private let columns: [GridItem]
    private let callback: () -> Void

    init(shortcuts: [ShortcutModel], width: CGFloat, callback: @escaping () -> Void = {}) {
        self.shortcuts = shortcuts
        self.callback = callback
        size = (width - (StyleConstant.Padding.large * CGFloat(colCount + 1))) / CGFloat(colCount)
        columns = [
            GridItem(.fixed(size), spacing: StyleConstant.Padding.large),
            GridItem(.fixed(size), spacing: 0),
        ]
    }

    var body: some View {
        LazyVGrid(columns: columns) {
            ForEach(shortcuts) { shortcut in
                switch shortcut.type {
                case ShortcutType.ARTIST.rawValue:
                    NavigationLink(destination: ArtistDetailPageView(artistId: shortcut.itemId.artistId)) {
                        ShortcutCellView(shortcut: shortcut, size: size)
                    }
                    .contentShape(RoundedRectangle(cornerRadius: StyleConstant.cornerRadius))
                    .contextMenu {
                        FavoriteArtistButtonView(artistId: shortcut.itemId.artistId)
                        ShortcutButtonView(itemId: shortcut.itemId.id, type: ShortcutType.ARTIST, callback: callback)
                    }
                case ShortcutType.ALBUM.rawValue:
                    NavigationLink(destination: AlbumDetailPageView(albumId: shortcut.itemId.albumId)) {
                        ShortcutCellView(shortcut: shortcut, size: size)
                    }
                    .contentShape(RoundedRectangle(cornerRadius: StyleConstant.cornerRadius))
                    .contextMenu {
                        ShortcutButtonView(itemId: shortcut.itemId.id, type: ShortcutType.ALBUM, callback: callback)
                    }
                case ShortcutType.PLAYLIST.rawValue:
                    NavigationLink(destination: PlaylistDetailPageView(playlistId: shortcut.itemId.playlistId)) {
                        ShortcutCellView(shortcut: shortcut, size: size)
                    }
                    .contentShape(RoundedRectangle(cornerRadius: StyleConstant.cornerRadius))
                    .contextMenu {
                        ShortcutButtonView(itemId: shortcut.itemId.id, type: ShortcutType.PLAYLIST, callback: callback)
                    }
                default:
                    EmptyView()
                }
            }
        }
    }
}
