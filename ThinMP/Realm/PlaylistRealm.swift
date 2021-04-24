//
//  PlaylistRealm.swift
//  ThinMP
//
//  Created by tk on 2021/03/30.
//

import RealmSwift
import Foundation

class PlaylistRealm: Object, Identifiable {
    @objc dynamic var id: String = UUID().uuidString
    @objc dynamic var name: String = ""
    @objc dynamic var order: Int = 1
    let songs = List<PlaylistSongRealm>()

    override static func primaryKey() -> String? {
        return "id"
    }
}
