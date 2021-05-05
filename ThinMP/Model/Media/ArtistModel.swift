//
//  ArtistModel.swift
//  ThinMP
//
//  Created by tk on 2020/01/06.
//

import MediaPlayer

struct ArtistModel: MediaProtocol, Identifiable {
    var id: String = UUID().uuidString
    var persistentId: MPMediaEntityPersistentID!
    var primaryText: String?
}
