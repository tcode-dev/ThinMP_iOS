//
//  AlbumDetailModel.swift
//  ThinMP
//
//  Created by tk on 2021/06/01.
//

import MediaPlayer

struct AlbumDetailModel: MediaProtocol {
    var albumId: AlbumId
    var primaryText: String?
    var secondaryText: String?
    var artwork: MPMediaItemArtwork?
    var songs: [SongModel]
}
