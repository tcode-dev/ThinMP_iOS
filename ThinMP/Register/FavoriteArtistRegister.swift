//
//  FavoriteArtist.swift
//  ThinMP
//
//  Created by tk on 2020/12/27.
//
import RealmSwift
import MediaPlayer

struct FavoriteArtistRegister {
    func add(id: MPMediaEntityPersistentID) {
        let realm = try! Realm()
        let favoriteArtist = FavoriteArtist()

        // MPMediaEntityPersistentID は UInt64のエイリアス
        // realmはUInt64を保存できないのでInt64に変換して保存する
        favoriteArtist.id = Int64(bitPattern: id)
        favoriteArtist.order = realm.objects(FavoriteArtist.self).count + 1

        try! realm.write {
            realm.add(favoriteArtist)
        }
    }
}
