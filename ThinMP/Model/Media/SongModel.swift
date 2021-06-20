//
//  SongModel.swift
//  ThinMP
//
//  Created by tk on 2021/05/04.
//

import MediaPlayer

struct SongModel: MediaProtocol, Identifiable {
    let media: MPMediaItemCollection

    var id: String {
        return String(songId.id)
    }
    var songId: SongId {
        get {
            SongId(id: media.persistentID)
        }
    }
    var primaryText: String? {
        get {
            media.representativeItem?.title
        }
    }
    var secondaryText: String? {
        get {
            media.representativeItem?.artist
        }
    }
    var artwork: MPMediaItemArtwork? {
        get {
            media.representativeItem?.artwork
        }
    }
    var artistPersistentId: MPMediaEntityPersistentID? {
        get {
            media.representativeItem?.artistPersistentID
        }
    }
}
