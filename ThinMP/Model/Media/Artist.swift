//
//  Artist.swift
//  ThinMP
//
//  Created by tk on 2020/01/06.
//

import MediaPlayer

struct Artist: Identifiable {
    var id = UUID()
    var persistentId: MPMediaEntityPersistentID!
    var name:String?
}
