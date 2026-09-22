//
//  ShortcutButtonView.swift
//  ThinMP
//
//  Created by tk on 2021/05/08.
//

import SwiftUI

/// コンテキストメニューに置く、ショートカットの登録 / 解除ボタン
/// 種別ごとの init で itemId と type の組み合わせを型で保証する
struct ShortcutButtonView: View {
    private let register = ShortcutRegister()
    private let itemId: ItemId
    private let type: ShortcutType
    private let callback: () -> Void

    init(artistId: ArtistId, callback: @escaping () -> Void = {}) {
        self.init(itemId: ItemId(artistId: artistId), type: .artist, callback: callback)
    }

    init(albumId: AlbumId, callback: @escaping () -> Void = {}) {
        self.init(itemId: ItemId(albumId: albumId), type: .album, callback: callback)
    }

    init(playlistId: PlaylistId, callback: @escaping () -> Void = {}) {
        self.init(itemId: ItemId(playlistId: playlistId), type: .playlist, callback: callback)
    }

    private init(itemId: ItemId, type: ShortcutType, callback: @escaping () -> Void) {
        self.itemId = itemId
        self.type = type
        self.callback = callback
    }

    var body: some View {
        RegisterToggleButtonView(
            addLabel: LabelConstant.addShortcut,
            removeLabel: LabelConstant.removeShortcut,
            exists: { register.exists(itemId: itemId, type: type) },
            add: { register.add(itemId: itemId, type: type) },
            remove: { register.delete(itemId: itemId, type: type) },
            callback: callback
        )
    }
}
