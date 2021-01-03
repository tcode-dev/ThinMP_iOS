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

    func add(id: MPMediaEntityPersistentID) {
        if (exists(id: id)) {
            return
        }

        let favoriteArtist = FavoriteArtistRealm()

        // MPMediaEntityPersistentID は UInt64のエイリアス
        // realmはUInt64を保存できないのでInt64に変換して保存する
        favoriteArtist.id = Int64(bitPattern: id)
        favoriteArtist.order = realm.objects(FavoriteArtistRealm.self).count + 1

        try! realm.write {
            realm.add(favoriteArtist)
        }
    }

    func delete(id: MPMediaEntityPersistentID) {
        let favoriteArtists = find(id: id)

        if (favoriteArtists.count != 1) {
            return
        }

        try! realm.write {
            realm.delete(favoriteArtists)
        }
    }

    func exists(id: MPMediaEntityPersistentID) -> Bool {
        return find(id: id).count == 1
    }

    func find(id: MPMediaEntityPersistentID) -> Results<FavoriteArtistRealm> {
        return realm.objects(FavoriteArtistRealm.self).filter("id = \(Int64(bitPattern: id))")
    }
}
