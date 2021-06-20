//
//  PlaylistDetailModel.swift
//  ThinMP
//
//  Created by tk on 2021/05/30.
//

import MediaPlayer

struct PlaylistDetailModel: DetailProtocol {
    var playlistId: PlaylistId
    var primaryText: String?
    var secondaryText:String?
    var artwork: MPMediaItemArtwork?
    var songs: [SongModel] = []
    var id: String {
        return playlistId.id
    }
    var shortcutId: String {
        return playlistId.id
    }
}
