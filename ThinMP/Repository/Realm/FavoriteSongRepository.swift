//
//  FavoriteSongRepository.swift
//  ThinMP
//
//  Created by tk on 2021/05/06.
//

import RealmSwift
import MediaPlayer

struct FavoriteSongRepository {
    var realm: Realm

    init() {
        realm = try! Realm()
    }

    func findAll() -> [MPMediaEntityPersistentID] {
        return realm.objects(FavoriteSongModel.self)
            .sorted(byKeyPath: "order")
            .map { UInt64(bitPattern: $0.persistentId) as MPMediaEntityPersistentID}
    }
}
