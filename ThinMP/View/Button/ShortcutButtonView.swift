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
    private let service: ShortcutServiceProtocol

    init(artistId: ArtistId, callback: @escaping () -> Void = {}, service: ShortcutServiceProtocol = ShortcutService()) {
        self.init(itemId: ItemId(artistId: artistId), type: .artist, callback: callback, service: service)
    }

    init(albumId: AlbumId, callback: @escaping () -> Void = {}, service: ShortcutServiceProtocol = ShortcutService()) {
        self.init(itemId: ItemId(albumId: albumId), type: .album, callback: callback, service: service)
    }

    init(playlistId: PlaylistId, callback: @escaping () -> Void = {}, service: ShortcutServiceProtocol = ShortcutService()) {
        self.init(itemId: ItemId(playlistId: playlistId), type: .playlist, callback: callback, service: service)
    }

    private init(itemId: ItemId, type: ShortcutType, callback: @escaping () -> Void, service: ShortcutServiceProtocol) {
        self.itemId = itemId
        self.type = type
        self.callback = callback
        self.service = service
    }

    var body: some View {
        RegisterToggleButtonView(
            addLabel: LabelConstant.addShortcut,
            removeLabel: LabelConstant.removeShortcut,
            exists: { service.exists(itemId: itemId, type: type) },
            add: { service.add(itemId: itemId, type: type) },
            remove: { service.delete(itemId: itemId, type: type) },
            callback: callback
        )
    }
}
