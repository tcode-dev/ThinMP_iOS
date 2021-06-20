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

    func findById(playlistId: PlaylistId) -> PlaylistRealmModel {
        return realm.objects(PlaylistRealmModel.self).filter("id = '\(playlistId.id)'").first!
    }

    func findByIds(playlistIds: [PlaylistId]) -> Results<PlaylistRealmModel> {
        return realm.objects(PlaylistRealmModel.self).filter("id IN %@", playlistIds.map{ $0.id })
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

    func add(playlistId: PlaylistId, persistentId: MPMediaEntityPersistentID) {
        let playlist = realm.objects(PlaylistRealmModel.self).filter("id = '\(playlistId.id)'").first!
        let song = PlaylistSongRealmModel()

        song.persistentId = Int64(bitPattern: persistentId)
        song.playlistId = playlist.id

        try! realm.write {
            playlist.songs.append(song)
        }
    }

    // プレイリスト一覧の更新
    func update(playlistIds: [PlaylistId]) {
        delete(playlistIds: playlistIds)
        sort(playlistIds: playlistIds)
    }

    // プレイリスト詳細の更新
    func update(playlistId: PlaylistId, name: String, persistentIds: [MPMediaEntityPersistentID]) {
        realm.beginWrite()

        let playlist = realm.objects(PlaylistRealmModel.self).filter("id = '\(playlistId.id)'").first!

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

    func delete(playlistIds: [PlaylistId]) {
        let currentIds: [String] = realm.objects(PlaylistRealmModel.self).map{$0.id}
        let deleteIds = currentIds.filter{ !playlistIds.map{$0.id}.contains($0)}
        let playlists = findByIds(playlistIds: deleteIds.map{PlaylistId(id: $0)})

        if (playlists.count == 0) {
            return
        }

        try! realm.write {
            realm.delete(playlists)
        }
    }

    private func sort(playlistIds: [PlaylistId]) {
        let playlists = findByIds(playlistIds: playlistIds)
        let sorted = playlistIds.map { playlistId in
            playlists.first{$0.id == playlistId.id}
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
