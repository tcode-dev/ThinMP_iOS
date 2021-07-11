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

    init(list: [ShortcutModel], width: CGFloat) {
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
                switch list[index].type {
                case ShortcutType.ARTIST.rawValue:
                    NavigationLink(destination: ArtistDetailPageView(artistId: list[index].itemId.artistId)) {
                        ShortcutCellView(shortcut: list[index], size: size)
                    }
                case ShortcutType.ALBUM.rawValue:
                    NavigationLink(destination: AlbumDetailPageView(albumId: list[index].itemId.albumId)) {
                        ShortcutCellView(shortcut: list[index], size: size)
                    }
                case ShortcutType.PLAYLIST.rawValue:
                    NavigationLink(destination: PlaylistDetailPageView(playlistId: list[index].itemId.playlistId)) {
                        ShortcutCellView(shortcut: list[index], size: size)
                    }
                default:
                    EmptyView()
                }
            }
        }
    }
}
