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
    var type: Int
    var primaryText: String?
    var artwork: MPMediaItemArtwork?
    var id: String {
        return shortcutId.id
    }
    var secondaryText: String? {
        get {
            if type == ShortcutType.ARTIST.rawValue {
                return "Artist"
            } else if type == ShortcutType.ALBUM.rawValue {
                return "Album"
            } else if type == ShortcutType.PLAYLIST.rawValue {
                return "Playlist"
            } else {
                return ""
            }
        }
    }
}
