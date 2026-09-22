//
//  FavoriteArtistRealmRepository.swift
//  ThinMP
//
//  Created by tk on 2021/05/06.
//

import RealmSwift

struct FavoriteArtistRealmRepository: FavoriteArtistRepositoryProtocol {
    private let realm: Realm

    init(store: RealmStore = .default) {
        realm = store.realm()
    }

    func findAll() -> [ArtistId] {
        return realm.objects(FavoriteArtistRealmModel.self)
            .sorted(byKeyPath: FavoriteArtistRealmModel.orderKey)
            .map { ArtistId(id: UInt64($0.artistId)!) }
    }

    func exists(artistId: ArtistId) -> Bool {
        return !find(artistId: artistId).isEmpty
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

    func update(artistIds: [ArtistId]) {
        truncate()
        bulkInsert(artistIds: artistIds)
    }

    func delete(artistId: ArtistId) {
        let favoriteArtists = find(artistId: artistId)

        if favoriteArtists.isEmpty {
            return
        }

        try! realm.write {
            realm.delete(favoriteArtists)
        }
    }

    private func bulkInsert(artistIds: [ArtistId]) {
        realm.beginWrite()

        for index in 0 ..< artistIds.count {
            realm.create(FavoriteArtistRealmModel.self, value: [
                FavoriteArtistRealmModel.artistIdKey: String(artistIds[index].id),
                FavoriteArtistRealmModel.orderKey: index,
            ])
        }

        try! realm.commitWrite()
    }

    private func find(artistId: ArtistId) -> Results<FavoriteArtistRealmModel> {
        return realm.objects(FavoriteArtistRealmModel.self).filter("\(FavoriteArtistRealmModel.artistIdKey) = '\(String(artistId.id))'")
    }

    private func truncate() {
        let results = realm.objects(FavoriteArtistRealmModel.self)
        if results.isEmpty {
            return
        }

        try! realm.write {
            realm.delete(results)
        }
    }

    private func incrementOrder() -> Int {
        return (realm.objects(FavoriteArtistRealmModel.self).max(ofProperty: FavoriteArtistRealmModel.orderKey) as Int? ?? 0) + 1
    }
}
