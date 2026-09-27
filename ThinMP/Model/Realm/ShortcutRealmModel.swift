//
//  ShortcutRealmModel.swift
//  ThinMP
//
//  Created by tk on 2021/05/08.
//

import Foundation
import RealmSwift

nonisolated class ShortcutRealmModel: Object {
    static let idKey: String = "id"
    static let itemIdKey: String = "itemId"
    static let typeKey: String = "type"
    static let orderKey: String = "order"

    @objc dynamic var id: String = UUID().uuidString
    @objc dynamic var itemId: String = ""
    @objc dynamic var type: Int = ShortcutType.artist.rawValue
    @objc dynamic var order: Int = 1

    override static func primaryKey() -> String {
        return idKey
    }
}
