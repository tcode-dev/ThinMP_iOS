//
//  SongModel.swift
//  ThinMP
//
//  Created by tk on 2021/05/04.
//

import MediaPlayer

struct SongModel: MediaProtocol, Identifiable {
    var id: String = UUID().uuidString

    let media: MPMediaItemCollection

    var persistentID: MPMediaEntityPersistentID {
        get {
            media.persistentID
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
}
