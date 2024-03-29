//
//  PlaylistRepository.swift
//  ThinMP
//
//  Created by tk on 2021/05/06.
//

import MediaPlayer
import RealmSwift

struct PlaylistRepository: PlaylistRepositoryProtocol {
    let realm: Realm

    init() {
        realm = try! Realm()
    }

    func create(songId: SongId, name: String) {
        let playlist = PlaylistRealmModel()

        playlist.name = name
        playlist.order = incrementOrder()

        let song = PlaylistSongRealmModel()

        song.songId = String(songId.id)
        song.playlistId = playlist.id

        playlist.songs.append(song)

        try! realm.write {
            realm.add(playlist)
        }
    }

    func add(playlistId: PlaylistId, songId: SongId) {
        let playlist = realm.objects(PlaylistRealmModel.self).filter("\(PlaylistRealmModel.ID) = '\(playlistId.id)'").first!
        let song = PlaylistSongRealmModel()

        song.songId = String(songId.id)
        song.playlistId = playlist.id

        try! realm.write {
            playlist.songs.append(song)
        }
    }

    func findAll() -> [PlaylistRealmModel] {
        return Array(realm.objects(PlaylistRealmModel.self).sorted(byKeyPath: PlaylistRealmModel.ORDER))
    }

    func findById(playlistId: PlaylistId) -> PlaylistRealmModel {
        return realm.objects(PlaylistRealmModel.self).filter("\(PlaylistRealmModel.ID) = '\(playlistId.id)'").first!
    }

    func findByIds(playlistIds: [PlaylistId]) -> [PlaylistRealmModel] {
        return Array(realm.objects(PlaylistRealmModel.self).filter("\(PlaylistRealmModel.ID) IN %@", playlistIds.map { $0.id }))
    }

    func update(playlistIds: [PlaylistId]) {
        let deleteIds = getDeleteIds(playlistIds: playlistIds)

        delete(playlistIds: deleteIds)
        sort(playlistIds: playlistIds)
    }

    func update(playlistId: PlaylistId, name: String, songIds: [SongId]) {
        realm.beginWrite()

        let playlist = realm.objects(PlaylistRealmModel.self).filter("\(PlaylistRealmModel.ID) = '\(playlistId.id)'").first!

        realm.delete(playlist.songs)

        songIds.forEach { songId in
            let song = PlaylistSongRealmModel()

            song.songId = String(songId.id)
            song.playlistId = playlist.id
            playlist.songs.append(song)
        }

        playlist.name = name

        try! realm.commitWrite()
    }

    func delete(playlistId: PlaylistId) {
        delete(playlistIds: [playlistId])
    }

    private func delete(playlistIds: [PlaylistId]) {
        let playlists = findByIds(playlistIds: playlistIds)

        if playlists.count == 0 {
            return
        }

        try! realm.write {
            realm.delete(playlists)
        }
    }

    private func sort(playlistIds: [PlaylistId]) {
        let playlists = findByIds(playlistIds: playlistIds)
        let sorted = playlistIds.map { playlistId in
            playlists.first { $0.id == playlistId.id }
        }

        try! realm.write {
            for (index, playlist) in sorted.enumerated() {
                playlist?.order = index
            }
        }
    }

    private func incrementOrder() -> Int {
        return (realm.objects(PlaylistRealmModel.self).max(ofProperty: PlaylistRealmModel.ORDER) as Int? ?? 0) + 1
    }

    private func getDeleteIds(playlistIds: [PlaylistId]) -> [PlaylistId] {
        let currentIds: [String] = realm.objects(PlaylistRealmModel.self).map { $0.id }

        return currentIds.filter { !playlistIds.map { $0.id }.contains($0) }.map { PlaylistId(id: $0) }
    }
}
