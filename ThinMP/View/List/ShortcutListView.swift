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
                NavigationLink(destination: destination(shortcut.target)) {
                    ShortcutCellView(shortcut: shortcut, size: layout.cellSize)
                }
                .contentShape(RoundedRectangle(cornerRadius: StyleConstant.cornerRadius))
                .contextMenu {
                    if case .artist(let artistId) = shortcut.target {
                        FavoriteArtistButtonView(artistId: artistId)
                    }
                    ShortcutButtonView(target: shortcut.target, callback: callback)
                }
            }
        }
    }

    @ViewBuilder
    private func destination(_ target: ShortcutTarget) -> some View {
        switch target {
        case .artist(let artistId): ArtistDetailPageView(artistId: artistId)
        case .album(let albumId): AlbumDetailPageView(albumId: albumId)
        case .playlist(let playlistId): PlaylistDetailPageView(playlistId: playlistId)
        }
    }
}
