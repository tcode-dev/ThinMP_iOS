//
//  ShortcutModel.swift
//  ThinMP
//
//  Created by tk on 2021/06/22.
//

import MediaPlayer

struct ShortcutModel: MediaProtocol, Identifiable {
    var shortcutId: ShortcutId
    var itemId: ItemId
    var type: ShortcutType
    var primaryText: String?
    var artwork: MPMediaItemArtwork?
    var id: String {
        return shortcutId.id
    }

    var secondaryText: String? {
        switch type {
        case .artist: return "Artist"
        case .album: return "Album"
        case .playlist: return "Playlist"
        }
    }
}
