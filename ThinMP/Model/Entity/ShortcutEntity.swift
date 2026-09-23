//
//  ShortcutEntity.swift
//  ThinMP
//
//  Created by tk on 2026/09/21.
//

/// Repository から返す永続化ストア非依存のショートカット
struct ShortcutEntity {
    let shortcutId: ShortcutId
    let target: ShortcutTarget
}
