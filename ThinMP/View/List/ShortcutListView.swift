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
    private let list: [ShortcutModel]
    private let size: CGFloat
    private let columns: [GridItem]
    private let callback: () -> Void
    
    init(list: [ShortcutModel], width: CGFloat, callback: @escaping () -> Void = {}) {
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
                switch list[index].type {
                case ShortcutType.ARTIST.rawValue:
                    NavigationLink(destination: ArtistDetailPageView(artistId: list[index].itemId.artistId)) {
                        ShortcutCellView(shortcut: list[index], size: size)
                    }
                    .contextMenu {
                        FavoriteArtistButtonView(artistId: list[index].itemId.artistId)
                        ShortcutButtonView(itemId: list[index].itemId.id, type: ShortcutType.ARTIST, callback: callback)
                    }
                case ShortcutType.ALBUM.rawValue:
                    NavigationLink(destination: AlbumDetailPageView(albumId: list[index].itemId.albumId)) {
                        ShortcutCellView(shortcut: list[index], size: size)
                    }
                    .contextMenu {
                        ShortcutButtonView(itemId: list[index].itemId.id, type: ShortcutType.ALBUM, callback: callback)
                    }
                case ShortcutType.PLAYLIST.rawValue:
                    NavigationLink(destination: PlaylistDetailPageView(playlistId: list[index].itemId.playlistId)) {
                        ShortcutCellView(shortcut: list[index], size: size)
                    }
                    .contextMenu {
                        ShortcutButtonView(itemId: list[index].itemId.id, type: ShortcutType.PLAYLIST, callback: callback)
                    }
                default:
                    EmptyView()
                }
            }
        }
    }
}
