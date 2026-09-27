//
//  AlbumDetailModel.swift
//  ThinMP
//
//  Created by tk on 2021/06/01.
//

import MediaPlayer

nonisolated struct AlbumDetailModel {
    let albumId: AlbumId
    let primaryText: String?
    let secondaryText: String?
    let artwork: MPMediaItemArtwork?
    let songs: [SongModel]
}
