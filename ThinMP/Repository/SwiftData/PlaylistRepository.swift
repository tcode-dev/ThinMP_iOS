//
//  PlaylistRepository.swift
//  ThinMP
//
//  Created by tk on 2026/09/21.
//

import Foundation
import SwiftData

struct PlaylistRepository: PlaylistRepositoryProtocol {
    private let store: SwiftDataStore

    init(store: SwiftDataStore = .default) {
        self.store = store
    }

    func create(songId: SongId, name: String) {
        let playlist = PlaylistDataModel(name: name, order: incrementOrder())
        let song = PlaylistSongDataModel(playlistId: playlist.id, songId: String(songId.id), order: 0)

        store.context.insert(playlist)
        store.context.insert(song)
        playlist.songs.append(song)
        store.save()
    }

    func add(playlistId: PlaylistId, songId: SongId) {
        guard let playlist = findModel(playlistId: playlistId) else {
            return
        }

        // 同じ曲は 1 つのプレイリストに 1 回しか登録しない
        if playlist.songs.contains(where: { $0.songId == String(songId.id) }) {
            return
        }

        let order = (playlist.songs.map { $0.order }.max() ?? -1) + 1
        let song = PlaylistSongDataModel(playlistId: playlist.id, songId: String(songId.id), order: order)

        store.context.insert(song)
        playlist.songs.append(song)
        store.save()
    }

    func findAll() -> [PlaylistEntity] {
        let descriptor = FetchDescriptor<PlaylistDataModel>(sortBy: [SortDescriptor(\.order)])

        return try! store.context.fetch(descriptor).map { toEntity(model: $0) }
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

        playlist.songs.forEach { store.context.delete($0) }

        // 同じ曲は最初の 1 回だけ残す(#Unique の upsert に任せると並び順が崩れるので先に弾く)
        for (index, songId) in songIds.uniqued().enumerated() {
            let song = PlaylistSongDataModel(playlistId: playlist.id, songId: String(songId.id), order: index)

            store.context.insert(song)
            playlist.songs.append(song)
        }

        playlist.name = name
        store.save()
    }

    func delete(playlistId: PlaylistId) {
        delete(playlistIds: [playlistId])
    }

    private func findModel(playlistId: PlaylistId) -> PlaylistDataModel? {
        let id = playlistId.id
        let descriptor = FetchDescriptor<PlaylistDataModel>(predicate: #Predicate { $0.id == id })

        return try! store.context.fetch(descriptor).first
    }

    private func findModels(playlistIds: [PlaylistId]) -> [PlaylistDataModel] {
        let ids = playlistIds.map { $0.id }
        let descriptor = FetchDescriptor<PlaylistDataModel>(predicate: #Predicate { ids.contains($0.id) }, sortBy: [SortDescriptor(\.order)])

        return try! store.context.fetch(descriptor)
    }

    private func toEntity(model: PlaylistDataModel) -> PlaylistEntity {
        let songIds = model.sortedSongs.map { SongId(id: UInt64($0.songId)!) }

        return PlaylistEntity(playlistId: PlaylistId(id: model.id), name: model.name, songIds: songIds)
    }

    private func delete(playlistIds: [PlaylistId]) {
        let playlists = findModels(playlistIds: playlistIds)

        if playlists.count == 0 {
            return
        }

        playlists.forEach { store.context.delete($0) }
        store.save()
    }

    private func sort(playlistIds: [PlaylistId]) {
        let playlists = findModels(playlistIds: playlistIds)

        for (index, playlistId) in playlistIds.enumerated() {
            playlists.first { $0.id == playlistId.id }?.order = index
        }

        store.save()
    }

    private func incrementOrder() -> Int {
        var descriptor = FetchDescriptor<PlaylistDataModel>(sortBy: [SortDescriptor(\.order, order: .reverse)])

        descriptor.fetchLimit = 1

        return (try! store.context.fetch(descriptor).first?.order ?? 0) + 1
    }

    private func getDeleteIds(playlistIds: [PlaylistId]) -> [PlaylistId] {
        let currentIds = try! store.context.fetch(FetchDescriptor<PlaylistDataModel>()).map { $0.id }
        let keepIds = playlistIds.map { $0.id }

        return currentIds.filter { !keepIds.contains($0) }.map { PlaylistId(id: $0) }
    }
}
