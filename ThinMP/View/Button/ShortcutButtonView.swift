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
    private let itemId: ItemId
    private let type: ShortcutType
    private let callback: () -> Void
    private let register: ShortcutRegisterProtocol

    init(artistId: ArtistId, callback: @escaping () -> Void = {}, register: ShortcutRegisterProtocol = ShortcutRegister()) {
        self.init(itemId: ItemId(artistId: artistId), type: .artist, callback: callback, register: register)
    }

    init(albumId: AlbumId, callback: @escaping () -> Void = {}, register: ShortcutRegisterProtocol = ShortcutRegister()) {
        self.init(itemId: ItemId(albumId: albumId), type: .album, callback: callback, register: register)
    }

    init(playlistId: PlaylistId, callback: @escaping () -> Void = {}, register: ShortcutRegisterProtocol = ShortcutRegister()) {
        self.init(itemId: ItemId(playlistId: playlistId), type: .playlist, callback: callback, register: register)
    }

    private init(itemId: ItemId, type: ShortcutType, callback: @escaping () -> Void, register: ShortcutRegisterProtocol) {
        self.itemId = itemId
        self.type = type
        self.callback = callback
        self.register = register
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
