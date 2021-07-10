//
//  FavoriteSongRepository.swift
//  ThinMP
//
//  Created by tk on 2021/05/06.
//

import RealmSwift
import MediaPlayer

struct FavoriteSongRepository {
    let realm: Realm

    init() {
        realm = try! Realm()
    }

    func findAll() -> [SongId] {
        return realm.objects(FavoriteSongRealmModel.self)
            .sorted(byKeyPath: FavoriteSongRealmModel.ORDER)
            .map { SongId(id: UInt64($0.songId)!)}
    }

    func add(songId: SongId) {
        if (exists(songId: songId)) {
            return
        }

        let favoriteSong = FavoriteSongRealmModel()

        // MPMediaEntityPersistentID は UInt64のエイリアス
        // realmはUInt64を保存できないのでStringに変換して保存する
        favoriteSong.songId = String(songId.id)
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
                FavoriteSongRealmModel.SONG_ID: String(songIds[index].id),
                FavoriteSongRealmModel.ORDER: index
            ])
        }

        try! realm.commitWrite()
    }

    private func find(songId: SongId) -> Results<FavoriteSongRealmModel> {
        return realm.objects(FavoriteSongRealmModel.self).filter("\(FavoriteSongRealmModel.SONG_ID) = '\(String(songId.id))'")
    }

    private func incrementOrder() -> Int {
        return (realm.objects(FavoriteSongRealmModel.self).max(ofProperty: FavoriteSongRealmModel.ORDER) as Int? ?? 0) + 1
    }
}
