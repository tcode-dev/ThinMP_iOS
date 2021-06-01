//
//  ArtistDetailModel.swift
//  ThinMP
//
//  Created by tk on 2021/05/31.
//

import MediaPlayer

struct ArtistDetailModel: DetailProtocol {
    var persistentId: MPMediaEntityPersistentID!
    var primaryText: String?
    var secondaryText:String?
    var artwork: MPMediaItemArtwork?
    var albums: [AlbumModel]
    var songs: [SongModel]
    var shortcutId: String {
        return String(persistentId)
    }
}
