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

    func exists(persistentId: MPMediaEntityPersistentID) -> Bool {
        return find(persistentId: persistentId).count == 1
    }

    private func truncate() {
        let results = realm.objects(FavoriteSongModel.self)
        if results.count == 0 {
            return
        }

        try! realm.write {
            realm.delete(results)
        }
    }

    private func bulkInsert(persistentIdList: [MPMediaEntityPersistentID]) {
        realm.beginWrite()

        for index in 0..<persistentIdList.count {
            realm.create(FavoriteSongModel.self, value: [
                "persistentId": persistentIdList[index],
                "order": index
            ])
        }

        try! realm.commitWrite()
    }

    private func find(persistentId: MPMediaEntityPersistentID) -> Results<FavoriteSongModel> {
        return realm.objects(FavoriteSongModel.self).filter("persistentId = \(Int64(bitPattern: persistentId))")
    }

    private func incrementOrder() -> Int {
        return (realm.objects(FavoriteSongModel.self).max(ofProperty: "order") as Int? ?? 0) + 1
    }
}
