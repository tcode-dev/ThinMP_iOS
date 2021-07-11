//
//  SongId.swift
//  ThinMP
//
//  Created by tk on 2021/06/21.
//

import MediaPlayer

struct SongId {
    var id: MPMediaEntityPersistentID

    func equals(_ songId: SongId) -> Bool {
        return songId.id == id
    }
}
