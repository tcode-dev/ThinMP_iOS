//
//  ShortcutType.swift
//  ThinMP
//
//  Created by tk on 2026/09/21.
//

/// rawValue はストアに保存されているので変更しない
enum ShortcutType: Int {
    case artist = 1
    case album = 2
    case playlist = 3
}

extension ShortcutType {
    /// 表示名。Localizable.strings のキー
    var label: String {
        switch self {
        case .artist: return LabelConstant.artist
        case .album: return LabelConstant.album
        case .playlist: return LabelConstant.playlist
        }
    }
}
