//
//  AlbumDetailModel.swift
//  ThinMP
//
//  Created by tk on 2021/06/01.
//

import MediaPlayer

struct AlbumDetailModel: DetailProtocol {
    var albumId: AlbumId
    var primaryText: String?
    var secondaryText: String?
    var artwork: MPMediaItemArtwork?
    var songs: [SongModel]
    var id: String {
        return String(albumId.id)
    }

    var shortcutId: String {
        return String(albumId.id)
    }
}
