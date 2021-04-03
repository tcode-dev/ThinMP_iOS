//
//  PlaylistRealm.swift
//  ThinMP
//
//  Created by tk on 2021/03/30.
//

import RealmSwift
import Foundation

class PlaylistRealm: Object {
    @objc dynamic var id: String = UUID().uuidString
    @objc dynamic var persistentId: Int64 = 0
    @objc dynamic var order: Int = 1

    override static func primaryKey() -> String? {
        return "id"
    }
}
