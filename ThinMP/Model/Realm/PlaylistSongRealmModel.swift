//
//  PlaylistSongRealmModel.swift
//  ThinMP
//
//  Created by tk on 2021/04/01.
//

import Foundation
import RealmSwift

class PlaylistSongRealmModel: Object {
    @objc dynamic var id: String = UUID().uuidString
    @objc dynamic var playlistId: String = ""
    @objc dynamic var persistentId: Int64 = 0
    @objc dynamic var order: Int = 1

    override static func primaryKey() -> String? {
        return "id"
    }
}
