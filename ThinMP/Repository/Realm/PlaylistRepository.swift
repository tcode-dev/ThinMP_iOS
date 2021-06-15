//
//  PlaylistRepository.swift
//  ThinMP
//
//  Created by tk on 2021/05/06.
//

import RealmSwift
import MediaPlayer

struct PlaylistRepository {
    var realm: Realm

    init() {
        realm = try! Realm()
    }

    func findAll() -> [PlaylistRealmModel] {
        return Array(realm.objects(PlaylistRealmModel.self).sorted(byKeyPath: "order"))
    }

    func findById(playlistId: String) -> PlaylistRealmModel {
        return realm.objects(PlaylistRealmModel.self).filter("id = '\(playlistId)'").first!
    }

    func findByIds(playlistIds: [String]) -> Results<PlaylistRealmModel> {
        return realm.objects(PlaylistRealmModel.self).filter("id IN %@", playlistIds)
    }

    func create(persistentId: MPMediaEntityPersistentID, name: String) {
        let playlist = PlaylistRealmModel()
        playlist.name = name
        playlist.order = incrementOrder()

        let song = PlaylistSongRealmModel()
        song.persistentId = Int64(bitPattern: persistentId)
        song.playlistId = playlist.id

        playlist.songs.append(song)

        try! realm.write {
            realm.add(playlist)
        }
    }

    func add(playlistId: String, persistentId: MPMediaEntityPersistentID) {
        let playlist = realm.objects(PlaylistRealmModel.self).filter("id = '\(playlistId)'").first!
        let song = PlaylistSongRealmModel()

        song.persistentId = Int64(bitPattern: persistentId)
        song.playlistId = playlist.id

        try! realm.write {
            playlist.songs.append(song)
        }
    }

    // プレイリスト一覧の更新
    func update(playlistIds: [String]) {
        delete(playlistIds: playlistIds)
        sort(playlistIds: playlistIds)
    }

    // プレイリスト詳細の更新
    func update(playlistId: String, name: String, persistentIds: [MPMediaEntityPersistentID]) {
        realm.beginWrite()

        let playlist = realm.objects(PlaylistRealmModel.self).filter("id = '\(playlistId)'").first!

        realm.delete(playlist.songs)

        persistentIds.forEach { persistentId in
            let song = PlaylistSongRealmModel()
            song.persistentId = Int64(bitPattern: persistentId)
            song.playlistId = playlist.id
            playlist.songs.append(song)
        }

        playlist.name = name

        try! realm.commitWrite()
    }

    func delete(playlistIds: [String]) {
        let currentIds: [String] = realm.objects(PlaylistRealmModel.self).map{$0.id}
        let deleteIds = currentIds.filter{ !playlistIds.contains($0)}
        let playlists = findByIds(playlistIds: deleteIds)

        if (playlists.count == 0) {
            return
        }

        try! realm.write {
            realm.delete(playlists)
        }
    }

    private func sort(playlistIds: [String]) {
        let playlists = findByIds(playlistIds: playlistIds)
        let sorted = playlistIds.map { id in
            playlists.first{$0.id == id}
        }
        try! realm.write {
            for (index, playlist) in sorted.enumerated() {
                playlist?.order = index
            }
        }
    }

    private func incrementOrder() -> Int {
        return (realm.objects(PlaylistRealmModel.self).max(ofProperty: "order") as Int? ?? 0) + 1
    }
}
