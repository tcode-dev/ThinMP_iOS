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
        let playlist = PlaylistDataModel(name: name, order: store.nextOrder(PlaylistDataModel.self, by: \.order))
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

    /// 渡したものだけを渡した順で残す。編集ページの並び替えと削除を反映する
    func update(playlistIds: [PlaylistId]) {
        let orderById = Dictionary(playlistIds.enumerated().map { ($1.id, $0) }, uniquingKeysWith: { first, _ in first })

        for model in try! store.context.fetch(FetchDescriptor<PlaylistDataModel>()) {
            if let order = orderById[model.id] {
                model.order = order
            } else {
                store.context.delete(model)
            }
        }

        store.save()
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
        guard let playlist = findModel(playlistId: playlistId) else {
            return
        }

        store.context.delete(playlist)
        store.save()
    }

    /// findById / findByIds にすると、戻り値の型だけが違う公開メソッドと同じ名前になり、呼び出しが曖昧になるので findModel(s) にしている
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

    /// persistentID として読めない曲は落とす(ShortcutTarget と同じ扱い)
    private func toEntity(model: PlaylistDataModel) -> PlaylistEntity {
        let songIds = model.sortedSongs.compactMap { UInt64($0.songId) }.map { SongId(id: $0) }

        return PlaylistEntity(playlistId: PlaylistId(id: model.id), name: model.name, songIds: songIds)
    }
}
