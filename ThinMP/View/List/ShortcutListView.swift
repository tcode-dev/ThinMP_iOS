//
//  ShortcutListView.swift
//  ThinMP
//
//  Created by tk on 2021/05/30.
//

import SwiftUI
import MediaPlayer

struct ShortcutListView: View {
    private let colCount = 2
    private let list: [ShortcutModel]
    private let size: CGFloat
    private let columns: [GridItem]

    init(list: [ShortcutModel], width: CGFloat) {
        self.list = list
        self.size = (width - (StyleConstant.padding.large * CGFloat(colCount + 1))) / CGFloat(colCount)
        self.columns = [
            GridItem(.fixed(size), spacing: StyleConstant.padding.large),
            GridItem(.fixed(size), spacing: 0)
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
