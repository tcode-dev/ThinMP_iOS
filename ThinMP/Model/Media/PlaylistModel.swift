//
//  PlaylistModel.swift
//  ThinMP
//
//  Created by tk on 2021/06/15.
//

import MediaPlayer

struct PlaylistModel: MediaProtocol, Identifiable {
    var id: String
    var primaryText: String?
    var secondaryText:String?
    var artwork: MPMediaItemArtwork?
    var shortcutId: String {
        return id
    }
}
