//
//  ItemId.swift
//  ThinMP
//
//  Created by tk on 2021/06/25.
//

import MediaPlayer

struct ItemId {
    var id: String
    var artistId: ArtistId {
        return ArtistId(id: UInt64(id)!)
    }

    var albumId: AlbumId {
        return AlbumId(id: UInt64(id)!)
    }

    var playlistId: PlaylistId {
        return PlaylistId(id: id)
    }
}
