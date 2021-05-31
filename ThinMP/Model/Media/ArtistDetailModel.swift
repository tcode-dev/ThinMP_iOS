//
//  ArtistDetailModel.swift
//  ThinMP
//
//  Created by tk on 2021/05/31.
//

import MediaPlayer

struct ArtistDetailModel {
    var primaryText: String?
    var secondaryText:String
    var artwork: MPMediaItemArtwork?
    var albums: [AlbumModel]
    var songs: [SongModel]
}
