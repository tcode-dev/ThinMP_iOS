//
//  FavoriteArtistRepository.swift
//  ThinMP
//
//  Created by tk on 2021/05/06.
//

import RealmSwift
import MediaPlayer

struct FavoriteArtistRepository {
    var realm: Realm

    init() {
        realm = try! Realm()
    }

    func findAll() -> [MPMediaEntityPersistentID] {
        let realm = try! Realm()

        return realm.objects(FavoriteArtistModel.self)
            .sorted(byKeyPath: "order")
            .map { UInt64(bitPattern: $0.persistentId) as MPMediaEntityPersistentID}
    }
}
