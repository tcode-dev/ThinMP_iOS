//
//  ShortcutModel.swift
//  ThinMP
//
//  Created by tk on 2021/06/22.
//

import MediaPlayer

/// 種別の表示名は target.type.label で、View が翻訳する
nonisolated struct ShortcutModel: Identifiable {
    let shortcutId: ShortcutId
    let target: ShortcutTarget
    let primaryText: String?
    let artwork: MPMediaItemArtwork?
    var id: ShortcutId {
        return shortcutId
    }
}
