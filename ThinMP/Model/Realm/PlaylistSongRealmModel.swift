//
//  PlaylistSongRealmModel.swift
//  ThinMP
//
//  Created by tk on 2021/04/01.
//

import Foundation
import RealmSwift

class PlaylistSongRealmModel: Object {
    static let ID: String = "id"
    static let PLAYLIST_ID: String = "playlistId"
    static let SONG_ID: String = "songId"
    static let ORDER: String = "order"

    @objc dynamic var id: String = UUID().uuidString
    @objc dynamic var playlistId: String = ""
    @objc dynamic var songId: String = ""
    @objc dynamic var order: Int = 1

    override static func primaryKey() -> String {
        return ID
    }
}
