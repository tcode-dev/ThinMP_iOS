//
//  PlaylistRegister.swift
//  ThinMP
//
//  Created by tk on 2021/03/30.
//

import RealmSwift
import MediaPlayer

struct PlaylistRegister {
    var realm: Realm

    init() {
        realm = try! Realm()
    }

    func add(persistentId: MPMediaEntityPersistentID) {
        if (exists(persistentId: persistentId)) {
            return
        }

        let playlistRealm = PlaylistRealm()

        // MPMediaEntityPersistentID は UInt64のエイリアス
        // realmはUInt64を保存できないのでInt64に変換して保存する
        playlistRealm.persistentId = Int64(bitPattern: persistentId)
        playlistRealm.order = incrementOrder()

        try! realm.write {
            realm.add(playlistRealm)
        }
    }

    func delete(persistentId: MPMediaEntityPersistentID) {
        let songs = find(persistentId: persistentId)

        if (songs.count != 1) {
            return
        }

        try! realm.write {
            realm.delete(songs)
        }
    }

    func update(persistentIdList: [MPMediaEntityPersistentID]) {
        truncate()
        bulkInsert(persistentIdList: persistentIdList)
    }

    func truncate() {
        let results = realm.objects(PlaylistRealm.self)
        if results.count == 0 {
            return
        }

        try! realm.write {
            realm.delete(results)
        }
    }

    func bulkInsert(persistentIdList: [MPMediaEntityPersistentID]) {
        realm.beginWrite()

        for index in 0..<persistentIdList.count {
            realm.create(PlaylistRealm.self, value: [
                "persistentId": persistentIdList[index],
                "order": index
            ])
        }

        try! realm.commitWrite()
    }

    func exists(persistentId: MPMediaEntityPersistentID) -> Bool {
        return find(persistentId: persistentId).count == 1
    }

    func find(persistentId: MPMediaEntityPersistentID) -> Results<PlaylistRealm> {
        return realm.objects(PlaylistRealm.self).filter("persistentId = \(Int64(bitPattern: persistentId))")
    }

    func incrementOrder() -> Int {
        return (realm.objects(PlaylistRealm.self).max(ofProperty: "order") as Int? ?? 0) + 1
    }
}
