//
//  PlaylistSongRealmModel.swift
//  ThinMP
//
//  Created by tk on 2021/04/01.
//

import Foundation
import RealmSwift

nonisolated class PlaylistSongRealmModel: Object {
    static let idKey: String = "id"
    static let orderKey: String = "order"

    @objc dynamic var id: String = UUID().uuidString
    @objc dynamic var playlistId: String = ""
    @objc dynamic var songId: String = ""
    @objc dynamic var order: Int = 1

    override static func primaryKey() -> String {
        return idKey
    }
}
