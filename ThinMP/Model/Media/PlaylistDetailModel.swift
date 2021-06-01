//
//  PlaylistDetailModel.swift
//  ThinMP
//
//  Created by tk on 2021/05/30.
//

import MediaPlayer

struct PlaylistDetailModel: DetailProtocol {
    var id: String
    var primaryText: String?
    var secondaryText:String?
    var artwork: MPMediaItemArtwork?
    var songs: [SongModel] = []
    var shortcutId: String {
        return id
    }
}
