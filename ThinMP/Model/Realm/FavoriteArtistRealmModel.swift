//
//  FavoriteArtistRealmModel.swift
//  ThinMP
//
//  Created by tk on 2020/12/27.
//

import Foundation
import RealmSwift

class FavoriteArtistRealmModel: Object {
    static let ID: String = "id"
    static let ARTIST_ID: String = "artistId"
    static let ORDER: String = "order"

    @objc dynamic var id: String = UUID().uuidString
    @objc dynamic var artistId: String = ""
    @objc dynamic var order: Int = 1

    override static func primaryKey() -> String? {
        return ID
    }
}
