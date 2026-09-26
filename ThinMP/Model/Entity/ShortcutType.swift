//
//  ShortcutType.swift
//  ThinMP
//
//  Created by tk on 2026/09/21.
//

import Foundation

/// rawValue はストアに保存されているので変更しない
nonisolated enum ShortcutType: Int {
    case artist = 1
    case album = 2
    case playlist = 3
}

nonisolated extension ShortcutType {
    /// 表示名
    var label: LocalizedStringResource {
        switch self {
        case .artist: return .artist
        case .album: return .album
        case .playlist: return .playlist
        }
    }
}
