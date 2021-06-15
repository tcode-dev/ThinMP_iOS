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

        return realm.objects(FavoriteArtistRealmModel.self)
            .sorted(byKeyPath: "order")
            .map { UInt64(bitPattern: $0.persistentId) as MPMediaEntityPersistentID}
    }

    func exists(persistentId: MPMediaEntityPersistentID) -> Bool {
        return find(persistentId: persistentId).count == 1
    }

    func add(persistentId: MPMediaEntityPersistentID) {
        if (exists(persistentId: persistentId)) {
            return
        }

        let favoriteArtist = FavoriteArtistRealmModel()

        // MPMediaEntityPersistentID は UInt64のエイリアス
        // realmはUInt64を保存できないのでInt64に変換して保存する
        favoriteArtist.persistentId = Int64(bitPattern: persistentId)
        favoriteArtist.order = incrementOrder()

        try! realm.write {
            realm.add(favoriteArtist)
        }
    }

    func delete(persistentId: MPMediaEntityPersistentID) {
        let favoriteArtists = find(persistentId: persistentId)

        if (favoriteArtists.count != 1) {
            return
        }

        try! realm.write {
            realm.delete(favoriteArtists)
        }
    }

    func update(persistentIdList: [MPMediaEntityPersistentID]) {
        truncate()
        bulkInsert(persistentIdList: persistentIdList)
    }

    private func find(persistentId: MPMediaEntityPersistentID) -> Results<FavoriteArtistRealmModel> {
        return realm.objects(FavoriteArtistRealmModel.self).filter("persistentId = \(Int64(bitPattern: persistentId))")
    }

    private func incrementOrder() -> Int {
        return (realm.objects(FavoriteArtistRealmModel.self).max(ofProperty: "order") as Int? ?? 0) + 1
    }

    private func truncate() {
        let results = realm.objects(FavoriteArtistRealmModel.self)
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
            realm.create(FavoriteArtistRealmModel.self, value: [
                "persistentId": persistentIdList[index],
                "order": index
            ])
        }

        try! realm.commitWrite()
    }
}
