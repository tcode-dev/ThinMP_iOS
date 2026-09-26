//
//  FavoriteArtistRealmModel.swift
//  ThinMP
//
//  Created by tk on 2020/12/27.
//

import Foundation
import RealmSwift

nonisolated class FavoriteArtistRealmModel: Object {
    static let idKey: String = "id"
    static let artistIdKey: String = "artistId"
    static let orderKey: String = "order"

    @objc dynamic var id: String = UUID().uuidString
    @objc dynamic var artistId: String = ""
    @objc dynamic var order: Int = 1

    override static func primaryKey() -> String {
        return idKey
    }
}
