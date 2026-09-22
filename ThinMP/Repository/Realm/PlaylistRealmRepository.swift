//
//  PlaylistRealmRepository.swift
//  ThinMP
//
//  Created by tk on 2021/05/06.
//

import RealmSwift

struct PlaylistRealmRepository: PlaylistRepositoryProtocol {
    private let realm: Realm

    init(store: RealmStore = .default) {
        realm = store.realm()
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
        guard let playlist = findModel(playlistId: playlistId) else {
            return
        }

        // 同じ曲は 1 つのプレイリストに 1 回しか登録しない
        if playlist.songs.contains(where: { $0.songId == String(songId.id) }) {
            return
        }

        let song = PlaylistSongRealmModel()

        song.songId = String(songId.id)
        song.playlistId = playlist.id

        try! realm.write {
            playlist.songs.append(song)
        }
    }

    func findAll() -> [PlaylistEntity] {
        return realm.objects(PlaylistRealmModel.self)
            .sorted(byKeyPath: PlaylistRealmModel.ORDER)
            .map { toEntity(model: $0) }
    }

    func findById(playlistId: PlaylistId) -> PlaylistEntity? {
        return findModel(playlistId: playlistId).map { toEntity(model: $0) }
    }

    func findByIds(playlistIds: [PlaylistId]) -> [PlaylistEntity] {
        return findModels(playlistIds: playlistIds).map { toEntity(model: $0) }
    }

    func update(playlistIds: [PlaylistId]) {
        let deleteIds = getDeleteIds(playlistIds: playlistIds)

        delete(playlistIds: deleteIds)
        sort(playlistIds: playlistIds)
    }

    func update(playlistId: PlaylistId, name: String, songIds: [SongId]) {
        guard let playlist = findModel(playlistId: playlistId) else {
            return
        }

        realm.beginWrite()
        realm.delete(playlist.songs)

        // 同じ曲は最初の 1 回だけ残す
        songIds.uniqued().forEach { songId in
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

    private func findModel(playlistId: PlaylistId) -> PlaylistRealmModel? {
        return realm.objects(PlaylistRealmModel.self).filter("\(PlaylistRealmModel.ID) = '\(playlistId.id)'").first
    }

    private func findModels(playlistIds: [PlaylistId]) -> Results<PlaylistRealmModel> {
        return realm.objects(PlaylistRealmModel.self).filter("\(PlaylistRealmModel.ID) IN %@", playlistIds.map { $0.id })
    }

    private func toEntity(model: PlaylistRealmModel) -> PlaylistEntity {
        let songIds = Array(
            model.songs
                .sorted(byKeyPath: PlaylistSongRealmModel.ORDER)
                .map { SongId(id: UInt64($0.songId)!) }
        )

        return PlaylistEntity(playlistId: PlaylistId(id: model.id), name: model.name, songIds: songIds)
    }

    private func delete(playlistIds: [PlaylistId]) {
        let playlists = findModels(playlistIds: playlistIds)

        if playlists.count == 0 {
            return
        }

        try! realm.write {
            realm.delete(playlists)
        }
    }

    private func sort(playlistIds: [PlaylistId]) {
        let playlists = findModels(playlistIds: playlistIds)
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
