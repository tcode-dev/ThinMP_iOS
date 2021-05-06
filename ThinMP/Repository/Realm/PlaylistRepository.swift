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

    func findAll() -> [PlaylistModel] {
        return Array(realm.objects(PlaylistModel.self).sorted(byKeyPath: "order"))
    }

    func findById(playlistId: String) -> PlaylistModel {
        return realm.objects(PlaylistModel.self).filter("id = '\(playlistId)'").first!
    }

    func create(persistentId: MPMediaEntityPersistentID, name: String) {
        let playlist = PlaylistModel()
        playlist.name = name
        playlist.order = incrementOrder()

        let song = PlaylistSongModel()
        song.persistentId = Int64(bitPattern: persistentId)
        song.playlistId = playlist.id

        playlist.songs.append(song)

        try! realm.write {
            realm.add(playlist)
        }
    }

    func add(playlistId: String, persistentId: MPMediaEntityPersistentID) {
        let playlist = realm.objects(PlaylistModel.self).filter("id = '\(playlistId)'").first!
        let song = PlaylistSongModel()

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

        let playlist = realm.objects(PlaylistModel.self).filter("id = '\(playlistId)'").first!
        let deletes = playlist.songs.filter("NOT persistentId IN %@", persistentIds)

        realm.delete(deletes)

        let updates = playlist.songs.filter("persistentId IN %@", persistentIds)

        for (index, persistentId) in persistentIds.enumerated() {
            updates.first { $0.persistentId == persistentId }!.order = index + 1
        }

        playlist.name = name

        try! realm.commitWrite()
    }

    func delete(playlistIds: [String]) {
        let currentIds: [String] = realm.objects(PlaylistModel.self).map{$0.id}
        let deleteIds = currentIds.filter{ !playlistIds.contains($0)}
        let playlists = find(playlistId: deleteIds)

        if (playlists.count == 0) {
            return
        }

        try! realm.write {
            realm.delete(playlists)
        }
    }

    private func sort(playlistIds: [String]) {
        let playlists = find(playlistId: playlistIds)
        let sorted = playlistIds.map { id in
            playlists.first{$0.id == id}
        }
        try! realm.write {
            for (index, playlist) in sorted.enumerated() {
                playlist?.order = index
            }
        }
    }

    private func find(playlistId: [String]) -> Results<PlaylistModel> {
        return realm.objects(PlaylistModel.self).filter("id IN %@", playlistId)
    }

    private func incrementOrder() -> Int {
        return (realm.objects(PlaylistModel.self).max(ofProperty: "order") as Int? ?? 0) + 1
    }
}
