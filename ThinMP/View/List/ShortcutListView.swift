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
    private let space: CGFloat = 20
    private var list: [ShortcutRealmModel]
    private var size: CGFloat
    private let columns:[GridItem]

    init(list: [ShortcutRealmModel], width: CGFloat) {
        self.list = list
        self.size = (width - (space * CGFloat(colCount + 1))) / CGFloat(colCount)
        self.columns = [
            GridItem(.fixed(size), spacing: space),
            GridItem(.fixed(size), spacing: 0),
        ]
    }

    var body: some View {
        LazyVGrid(columns: columns) {
            ForEach(list.indices, id: \.self) { index in
                switch list[index].type {
                case ShortcutType.ARTIST.rawValue:
                    NavigationLink(destination: ArtistDetailPageView(artistId: ArtistId(id: UInt64(list[index].itemId)!))) {
                        ShortcutCellView(shortcut: list[index], size: size)
                    }
                case ShortcutType.ALBUM.rawValue:
                    NavigationLink(destination: AlbumDetailPageView(persistentId: UInt64(list[index].itemId)! as MPMediaEntityPersistentID)) {
                        ShortcutCellView(shortcut: list[index], size: size)
                    }
                case ShortcutType.PLAYLIST.rawValue:
                    NavigationLink(destination: PlaylistDetailPageView(playlistId: PlaylistId(id: list[index].itemId))) {
                        ShortcutCellView(shortcut: list[index], size: size)
                    }
                default:
                    EmptyView()
                }
            }
        }
    }
}

