//
//  AlbumModel.swift
//  ThinMP
//
//  Created by tk on 2019/10/28.
//

import MediaPlayer

struct AlbumModel: MediaProtocol, Identifiable {
    var id = UUID()
    var persistentId: MPMediaEntityPersistentID!
    var primaryText: String?
    var secondaryText: String?
    var artwork: MPMediaItemArtwork?

    var shortcutId: String {
        return String(persistentId)
    }
}
