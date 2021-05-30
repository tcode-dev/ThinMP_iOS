//
//  PlaylistDetailModel.swift
//  ThinMP
//
//  Created by tk on 2021/05/30.
//

import MediaPlayer

struct PlaylistDetailModel {
    var primaryText: String
    var artwork: MPMediaItemArtwork?
    var list: [SongModel] = []
}
