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

    func findAll() -> [ArtistId] {
        let realm = try! Realm()

        return realm.objects(FavoriteArtistRealmModel.self)
            .sorted(byKeyPath: "order")
            .map { ArtistId(id: UInt64(bitPattern: $0.persistentId))}
    }

    func exists(artistId: ArtistId) -> Bool {
        return find(artistId: artistId).count == 1
    }

    func add(artistId: ArtistId) {
        if (exists(artistId: artistId)) {
            return
        }

        let favoriteArtist = FavoriteArtistRealmModel()

        // MPMediaEntityPersistentID は UInt64のエイリアス
        // realmはUInt64を保存できないのでInt64に変換して保存する
        favoriteArtist.persistentId = Int64(bitPattern: artistId.id)
        favoriteArtist.order = incrementOrder()

        try! realm.write {
            realm.add(favoriteArtist)
        }
    }

    func delete(artistId: ArtistId) {
        let favoriteArtists = find(artistId: artistId)

        if (favoriteArtists.count != 1) {
            return
        }

        try! realm.write {
            realm.delete(favoriteArtists)
        }
    }

    func update(artistIds: [ArtistId]) {
        truncate()
        bulkInsert(artistIds: artistIds)
    }

    private func find(artistId: ArtistId) -> Results<FavoriteArtistRealmModel> {
        return realm.objects(FavoriteArtistRealmModel.self).filter("persistentId = \(Int64(bitPattern: artistId.id))")
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

    private func bulkInsert(artistIds: [ArtistId]) {
        realm.beginWrite()

        for index in 0..<artistIds.count {
            realm.create(FavoriteArtistRealmModel.self, value: [
                "persistentId": artistIds[index].id,
                "order": index
            ])
        }

        try! realm.commitWrite()
    }
}
