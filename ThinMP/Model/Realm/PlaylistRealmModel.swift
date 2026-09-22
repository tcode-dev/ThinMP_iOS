//
//  PlaylistRealmModel.swift
//  ThinMP
//
//  Created by tk on 2021/03/30.
//

import Foundation
import RealmSwift

class PlaylistRealmModel: Object {
    static let idKey: String = "id"
    static let orderKey: String = "order"

    @objc dynamic var id: String = UUID().uuidString
    @objc dynamic var name: String = ""
    @objc dynamic var order: Int = 1

    let songs = List<PlaylistSongRealmModel>()

    override static func primaryKey() -> String {
        return idKey
    }
}
