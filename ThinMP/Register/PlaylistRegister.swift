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


    func create(persistentId: MPMediaEntityPersistentID, name: String) {
        let playlist = PlaylistRealm()
        playlist.name = name
        playlist.order = incrementOrder()

        let song = PlaylistSongRealm()
        song.persistentId = Int64(bitPattern: persistentId)
        song.playlistId = playlist.id

        playlist.songs.append(song)

        try! realm.write {
            realm.add(playlist)
        }
    }

    func add(playlistId: String, persistentId: MPMediaEntityPersistentID) {
        let playlist = realm.objects(PlaylistRealm.self).filter("id = '\(playlistId)'").first!
        let song = PlaylistSongRealm()

        song.persistentId = Int64(bitPattern: persistentId)
        song.playlistId = playlist.id

        try! realm.write {
            playlist.songs.append(song)
        }
    }

    func incrementOrder() -> Int {
        return (realm.objects(PlaylistRealm.self).max(ofProperty: "order") as Int? ?? 0) + 1
    }
}
