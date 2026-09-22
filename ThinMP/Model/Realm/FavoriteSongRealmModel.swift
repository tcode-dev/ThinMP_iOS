//
//  FavoriteSongRealmModel.swift
//  ThinMP
//
//  Created by tk on 2021/02/20.
//

import Foundation
import RealmSwift

class FavoriteSongRealmModel: Object {
    static let idKey: String = "id"
    static let songIdKey: String = "songId"
    static let orderKey: String = "order"

    @objc dynamic var id: String = UUID().uuidString
    @objc dynamic var songId: String = ""
    @objc dynamic var order: Int = 1

    override static func primaryKey() -> String {
        return idKey
    }
}
