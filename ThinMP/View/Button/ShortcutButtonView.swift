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
    private let repository: ShortcutRepositoryProtocol

    init(artistId: ArtistId, callback: @escaping () -> Void = {}, repository: ShortcutRepositoryProtocol = ShortcutRepository()) {
        self.init(itemId: ItemId(artistId: artistId), type: .artist, callback: callback, repository: repository)
    }

    init(albumId: AlbumId, callback: @escaping () -> Void = {}, repository: ShortcutRepositoryProtocol = ShortcutRepository()) {
        self.init(itemId: ItemId(albumId: albumId), type: .album, callback: callback, repository: repository)
    }

    init(playlistId: PlaylistId, callback: @escaping () -> Void = {}, repository: ShortcutRepositoryProtocol = ShortcutRepository()) {
        self.init(itemId: ItemId(playlistId: playlistId), type: .playlist, callback: callback, repository: repository)
    }

    private init(itemId: ItemId, type: ShortcutType, callback: @escaping () -> Void, repository: ShortcutRepositoryProtocol) {
        self.itemId = itemId
        self.type = type
        self.callback = callback
        self.repository = repository
    }

    var body: some View {
        RegisterToggleButtonView(
            addLabel: LabelConstant.addShortcut,
            removeLabel: LabelConstant.removeShortcut,
            exists: { repository.exists(itemId: itemId, type: type) },
            add: { repository.add(itemId: itemId, type: type) },
            remove: { repository.delete(itemId: itemId, type: type) },
            callback: callback
        )
    }
}
