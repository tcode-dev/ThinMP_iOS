//
//  AlbumDetailModel.swift
//  ThinMP
//
//  Created by tk on 2021/06/01.
//

import MediaPlayer

struct AlbumDetailModel: MediaProtocol {
    let albumId: AlbumId
    let primaryText: String?
    let secondaryText: String?
    let artwork: MPMediaItemArtwork?
    let songs: [SongModel]
}
