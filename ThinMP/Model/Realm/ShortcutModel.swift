//
//  ShortcutModel.swift
//  ThinMP
//
//  Created by tk on 2021/05/08.
//

import Foundation
import RealmSwift

enum ShortcutType: Int {
    case ARTIST = 1
    case ALBUM = 2
    case PLAYLIST = 3
}

class ShortcutModel: Object {
    @objc dynamic var id: String = UUID().uuidString
    @objc dynamic var itemId: String = ""
    @objc dynamic var type: Int = ShortcutType.ARTIST.rawValue
    @objc dynamic var order: Int = 1

    override static func primaryKey() -> String? {
        return "id"
    }
}
