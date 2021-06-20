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

    func findAll() -> [SongId] {
        return realm.objects(FavoriteSongRealmModel.self)
            .sorted(byKeyPath: "order")
            .map { SongId(id: UInt64(bitPattern: $0.persistentId))}
    }

    func add(songId: SongId) {
        if (exists(songId: songId)) {
            return
        }

        let favoriteSong = FavoriteSongRealmModel()

        // MPMediaEntityPersistentID は UInt64のエイリアス
        // realmはUInt64を保存できないのでInt64に変換して保存する
        favoriteSong.persistentId = Int64(bitPattern: songId.id)
        favoriteSong.order = incrementOrder()

        try! realm.write {
            realm.add(favoriteSong)
        }
    }

    func delete(songId: SongId) {
        let favoriteSongs = find(songId: songId)

        if (favoriteSongs.count != 1) {
            return
        }

        try! realm.write {
            realm.delete(favoriteSongs)
        }
    }

    func update(songIds: [SongId]) {
        truncate()
        bulkInsert(songIds: songIds)
    }

    func exists(songId: SongId) -> Bool {
        return find(songId: songId).count == 1
    }

    private func truncate() {
        let results = realm.objects(FavoriteSongRealmModel.self)
        if results.count == 0 {
            return
        }

        try! realm.write {
            realm.delete(results)
        }
    }

    private func bulkInsert(songIds: [SongId]) {
        realm.beginWrite()

        for index in 0..<songIds.count {
            realm.create(FavoriteSongRealmModel.self, value: [
                "persistentId": songIds[index],
                "order": index
            ])
        }

        try! realm.commitWrite()
    }

    private func find(songId: SongId) -> Results<FavoriteSongRealmModel> {
        return realm.objects(FavoriteSongRealmModel.self).filter("persistentId = \(Int64(bitPattern: songId.id))")
    }

    private func incrementOrder() -> Int {
        return (realm.objects(FavoriteSongRealmModel.self).max(ofProperty: "order") as Int? ?? 0) + 1
    }
}
