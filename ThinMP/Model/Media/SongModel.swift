//
//  SongModel.swift
//  ThinMP
//
//  Created by tk on 2021/05/04.
//

import MediaPlayer

/// ライブラリの曲 1 件。再生キューに入れるので MPMediaItem をそのまま持つ
struct SongModel: MediaProtocol, Identifiable {
    let item: MPMediaItem

    var id: String {
        return String(songId.id)
    }

    var songId: SongId {
        return SongId(id: item.persistentID)
    }

    var artistId: ArtistId {
        return ArtistId(id: item.artistPersistentID)
    }

    var albumId: AlbumId {
        return AlbumId(id: item.albumPersistentID)
    }

    var primaryText: String? {
        return item.title
    }

    var secondaryText: String? {
        return item.artist
    }

    var artwork: MPMediaItemArtwork? {
        return item.artwork
    }
}
