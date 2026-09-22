//
//  ShortcutModel.swift
//  ThinMP
//
//  Created by tk on 2021/06/22.
//

import MediaPlayer

struct ShortcutModel: MediaProtocol, Identifiable {
    var shortcutId: ShortcutId
    var target: ShortcutTarget
    var primaryText: String?
    var artwork: MPMediaItemArtwork?
    var id: String {
        return shortcutId.id
    }

    /// 種別の表示名。SecondaryTextView はローカライズしないのでここで解決する
    var secondaryText: String? {
        return NSLocalizedString(target.type.label, comment: "")
    }
}
