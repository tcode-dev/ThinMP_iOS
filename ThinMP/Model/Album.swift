//
//  Album.swift
//  ThinMP
//
//  Created by tk on 2019/10/28.
//

import MediaPlayer

class Album {
    var persistentID: MPMediaEntityPersistentID?
    var title: String?
    var artist: String?
    var artwork: MPMediaItemArtwork?
    var songs: [MPMediaItem]

    
    init(persistentID: MPMediaEntityPersistentID, title: String?, artist: String?, artwork: MPMediaItemArtwork?, songs: [MPMediaItem]) {
        self.persistentID = persistentID
        self.title = title
        self.artist = artist
        self.artwork = artwork
        self.songs = songs
    }
}
