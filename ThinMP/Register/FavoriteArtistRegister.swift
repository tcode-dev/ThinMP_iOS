//
//  FavoriteArtist.swift
//  ThinMP
//
//  Created by tk on 2020/12/27.
//
import RealmSwift
import MediaPlayer

struct FavoriteArtistRegister {
    var realm: Realm

    init() {
        realm = try! Realm()
    }

    func add(persistentId: MPMediaEntityPersistentID) {
        if (exists(persistentId: persistentId)) {
            return
        }

        let favoriteArtist = FavoriteArtistRealm()

        // MPMediaEntityPersistentID は UInt64のエイリアス
        // realmはUInt64を保存できないのでInt64に変換して保存する
        favoriteArtist.persistentId = Int64(bitPattern: persistentId)
        favoriteArtist.order = realm.objects(FavoriteArtistRealm.self).count + 1

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

    func exists(persistentId: MPMediaEntityPersistentID) -> Bool {
        return find(persistentId: persistentId).count == 1
    }

    func find(persistentId: MPMediaEntityPersistentID) -> Results<FavoriteArtistRealm> {
        return realm.objects(FavoriteArtistRealm.self).filter("persistentId = \(Int64(bitPattern: persistentId))")
    }
}
