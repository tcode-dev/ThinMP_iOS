//
//  ShortcutModel.swift
//  ThinMP
//
//  Created by tk on 2021/06/22.
//

import MediaPlayer

struct ShortcutModel: MediaProtocol, Identifiable {
    var id: String
    var itemId: String
    var type: Int
    var primaryText: String?
    var artwork: MPMediaItemArtwork?
    var secondaryText: String? {
        get {
            if (type == ShortcutType.ARTIST.rawValue) {
                return "Artist"
            } else if (type == ShortcutType.ALBUM.rawValue) {
                return "Album"
            } else if(type == ShortcutType.PLAYLIST.rawValue) {
                return "Playlist"
            } else {
                return ""
            }
        }
    }
}
