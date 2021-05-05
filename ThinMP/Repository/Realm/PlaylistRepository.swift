//
//  PlaylistRepository.swift
//  ThinMP
//
//  Created by tk on 2021/05/06.
//

import RealmSwift
import MediaPlayer

struct PlaylistRepository {
    var realm: Realm

    init() {
        realm = try! Realm()
    }

    func findAll() -> [PlaylistModel] {
        return Array(realm.objects(PlaylistModel.self).sorted(byKeyPath: "order"))
    }

    func findById(playlistId: String) -> PlaylistModel {
        return realm.objects(PlaylistModel.self).filter("id = '\(playlistId)'").first!
    }
}

