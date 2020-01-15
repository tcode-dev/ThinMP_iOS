//
//  Song.swift
//  ThinMP
//
//  Created by tk on 2020/01/13.
//

import MediaPlayer

struct Song: Identifiable {
    var id = UUID()
    var title: String?
    var artist: String?
    var artwork: MPMediaItemArtwork?
}
