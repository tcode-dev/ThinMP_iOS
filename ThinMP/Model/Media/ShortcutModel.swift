//
//  ShortcutModel.swift
//  ThinMP
//
//  Created by tk on 2021/06/22.
//

import MediaPlayer

/// 種別の表示名は target.type.label(Localizable.strings のキー)で、View が翻訳する
struct ShortcutModel: Identifiable {
    var shortcutId: ShortcutId
    var target: ShortcutTarget
    var primaryText: String?
    var artwork: MPMediaItemArtwork?
    var id: ShortcutId {
        return shortcutId
    }
}
