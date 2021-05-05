//
//  FavoriteSongRegister.swift
//  ThinMP
//
//  Created by tk on 2021/02/20.
//

import RealmSwift
import MediaPlayer

struct FavoriteSongRegister {
    var realm: Realm

    init() {
        realm = try! Realm()
    }

    func add(persistentId: MPMediaEntityPersistentID) {
        if (exists(persistentId: persistentId)) {
            return
        }

        let favoriteSong = FavoriteSongModel()

        // MPMediaEntityPersistentID は UInt64のエイリアス
        // realmはUInt64を保存できないのでInt64に変換して保存する
        favoriteSong.persistentId = Int64(bitPattern: persistentId)
        favoriteSong.order = incrementOrder()

        try! realm.write {
            realm.add(favoriteSong)
        }
    }

    func delete(persistentId: MPMediaEntityPersistentID) {
        let favoriteSongs = find(persistentId: persistentId)

        if (favoriteSongs.count != 1) {
            return
        }

        try! realm.write {
            realm.delete(favoriteSongs)
        }
    }

    func update(persistentIdList: [MPMediaEntityPersistentID]) {
        truncate()
        bulkInsert(persistentIdList: persistentIdList)
    }

    func truncate() {
        let results = realm.objects(FavoriteSongModel.self)
        if results.count == 0 {
            return
        }

        try! realm.write {
            realm.delete(results)
        }
    }

    func bulkInsert(persistentIdList: [MPMediaEntityPersistentID]) {
        realm.beginWrite()

        for index in 0..<persistentIdList.count {
            realm.create(FavoriteSongModel.self, value: [
                "persistentId": persistentIdList[index],
                "order": index
            ])
        }

        try! realm.commitWrite()
    }

    func exists(persistentId: MPMediaEntityPersistentID) -> Bool {
        return find(persistentId: persistentId).count == 1
    }

    func find(persistentId: MPMediaEntityPersistentID) -> Results<FavoriteSongModel> {
        return realm.objects(FavoriteSongModel.self).filter("persistentId = \(Int64(bitPattern: persistentId))")
    }

    func incrementOrder() -> Int {
        return (realm.objects(FavoriteSongModel.self).max(ofProperty: "order") as Int? ?? 0) + 1
    }
}
