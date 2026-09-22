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
                NavigationLink(destination: destination(shortcut)) {
                    ShortcutCellView(shortcut: shortcut, size: layout.cellSize)
                }
                .contentShape(RoundedRectangle(cornerRadius: StyleConstant.cornerRadius))
                .contextMenu {
                    if shortcut.type == .artist {
                        FavoriteArtistButtonView(artistId: shortcut.itemId.artistId)
                    }
                    shortcutButton(shortcut)
                }
            }
        }
    }

    @ViewBuilder
    private func destination(_ shortcut: ShortcutModel) -> some View {
        switch shortcut.type {
        case .artist: ArtistDetailPageView(artistId: shortcut.itemId.artistId)
        case .album: AlbumDetailPageView(albumId: shortcut.itemId.albumId)
        case .playlist: PlaylistDetailPageView(playlistId: shortcut.itemId.playlistId)
        }
    }

    private func shortcutButton(_ shortcut: ShortcutModel) -> ShortcutButtonView {
        switch shortcut.type {
        case .artist: return ShortcutButtonView(artistId: shortcut.itemId.artistId, callback: callback)
        case .album: return ShortcutButtonView(albumId: shortcut.itemId.albumId, callback: callback)
        case .playlist: return ShortcutButtonView(playlistId: shortcut.itemId.playlistId, callback: callback)
        }
    }
}
