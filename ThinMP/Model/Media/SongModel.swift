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
        SongId(id: media.persistentID)
    }

    var primaryText: String? {
        media.representativeItem?.title
    }

    var secondaryText: String? {
        media.representativeItem?.artist
    }

    var artwork: MPMediaItemArtwork? {
        media.representativeItem?.artwork
    }

    var artistId: ArtistId? {
        if let artistPersistentID = media.representativeItem?.artistPersistentID {
            return ArtistId(id: artistPersistentID)
        }

        return Optional.none
    }
}
