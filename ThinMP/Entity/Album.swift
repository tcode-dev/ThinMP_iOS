//
//  Album.swift
//  ThinMP
//
//  Created by tk on 2019/10/28.
//

import MediaPlayer

struct Album: Identifiable {
    var id: Int
    var persistentID: MPMediaEntityPersistentID?
    var title: String?
    var artist: String?
    var artwork: MPMediaItemArtwork?
}
