//
//  AlbumModel.swift
//  ThinMP
//
//  Created by tk on 2019/10/28.
//

import MediaPlayer

struct AlbumModel: MediaProtocol, Identifiable {
    var albumId: AlbumId
    var primaryText: String?
    var secondaryText: String?
    var artwork: MPMediaItemArtwork?
    var id: String {
        return String(albumId.id)
    }
    var shortcutId: String {
        return String(albumId.id)
    }
}
