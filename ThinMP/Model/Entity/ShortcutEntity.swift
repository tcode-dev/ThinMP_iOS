//
//  ShortcutEntity.swift
//  ThinMP
//
//  Created by tk on 2026/09/21.
//

/// Repository から返す永続化ストア非依存のショートカット
struct ShortcutEntity {
    var shortcutId: ShortcutId
    var itemId: ItemId
    var type: ShortcutType
}

extension ShortcutEntity {
    /// ストアの行から作る
    /// type が不明な行と、アーティスト / アルバムなのに itemId が persistentID として読めない行は nil にして落とす
    /// ここで弾いておくことで ItemId.artistId / albumId の変換が失敗しない
    init?(id: String, itemId: String, type rawType: Int) {
        guard let type = ShortcutType(rawValue: rawType) else {
            return nil
        }

        switch type {
        case .artist, .album:
            if UInt64(itemId) == nil {
                return nil
            }
        case .playlist:
            break
        }

        self.init(shortcutId: ShortcutId(id: id), itemId: ItemId(id: itemId), type: type)
    }
}
