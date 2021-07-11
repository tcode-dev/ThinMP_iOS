//
//  FavoriteArtistRepository.swift
//  ThinMP
//
//  Created by tk on 2021/05/06.
//

import RealmSwift
import MediaPlayer

struct FavoriteArtistRepository {
    let realm: Realm

    init() {
        realm = try! Realm()
    }

    func findAll() -> [ArtistId] {
        let realm = try! Realm()

        return realm.objects(FavoriteArtistRealmModel.self)
            .sorted(byKeyPath: FavoriteArtistRealmModel.ORDER)
            .map { ArtistId(id: UInt64($0.artistId)!)}
    }

    func exists(artistId: ArtistId) -> Bool {
        return find(artistId: artistId).count == 1
    }

    func add(artistId: ArtistId) {
        if exists(artistId: artistId) {
            return
        }

        let favoriteArtist = FavoriteArtistRealmModel()

        favoriteArtist.artistId = String(artistId.id)
        favoriteArtist.order = incrementOrder()

        try! realm.write {
            realm.add(favoriteArtist)
        }
    }

    func delete(artistId: ArtistId) {
        let favoriteArtists = find(artistId: artistId)

        if favoriteArtists.count != 1 {
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
        return realm.objects(FavoriteArtistRealmModel.self).filter("\(FavoriteArtistRealmModel.ARTIST_ID) = '\(String(artistId.id))'")
    }

    private func incrementOrder() -> Int {
        return (realm.objects(FavoriteArtistRealmModel.self).max(ofProperty: FavoriteArtistRealmModel.ORDER) as Int? ?? 0) + 1
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
                FavoriteArtistRealmModel.ARTIST_ID: String(artistIds[index].id),
                FavoriteArtistRealmModel.ORDER: index
            ])
        }

        try! realm.commitWrite()
    }
}
