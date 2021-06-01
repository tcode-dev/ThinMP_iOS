//
//  AlbumDetailModel.swift
//  ThinMP
//
//  Created by tk on 2021/06/01.
//

import MediaPlayer

struct AlbumDetailModel: DetailProtocol {
    var persistentId: MPMediaEntityPersistentID!
    var primaryText: String?
    var secondaryText:String?
    var artwork: MPMediaItemArtwork?
    var songs: [SongModel]
    var shortcutId: String {
        return String(persistentId)
    }
}
