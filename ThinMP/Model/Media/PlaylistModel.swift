//
//  PlaylistModel.swift
//  ThinMP
//
//  Created by tk on 2021/06/15.
//

import MediaPlayer

struct PlaylistModel: MediaProtocol, Identifiable {
    var playlistId: PlaylistId
    var primaryText: String?
    var secondaryText:String?
    var artwork: MPMediaItemArtwork?
    var shortcutId: String {
        return playlistId.id
    }
    var id: String {
        return playlistId.id
    }
}
