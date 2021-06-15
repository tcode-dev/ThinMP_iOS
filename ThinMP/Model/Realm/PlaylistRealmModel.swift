//
//  PlaylistRealmModel.swift
//  ThinMP
//
//  Created by tk on 2021/03/30.
//

import Foundation
import RealmSwift

class PlaylistRealmModel: Object, MediaProtocol, Identifiable {
    @objc dynamic var id: String = UUID().uuidString
    @objc dynamic var name: String = ""
    @objc dynamic var order: Int = 1

    let songs = List<PlaylistSongRealmModel>()

    override static func primaryKey() -> String? {
        return "id"
    }

    var primaryText: String? {
        get {
            self.name
        }
    }

    var shortcutId: String {
        return id
    }
}
