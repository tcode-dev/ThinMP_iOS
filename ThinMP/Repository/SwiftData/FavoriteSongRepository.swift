//
//  FavoriteSongRepository.swift
//  ThinMP
//
//  Created by tk on 2026/09/21.
//

import Foundation
import SwiftData

struct FavoriteSongRepository: FavoriteSongRepositoryProtocol {
    private let store: SwiftDataStore

    init(store: SwiftDataStore = .default) {
        self.store = store
    }

    func add(songId: SongId) {
        if exists(songId: songId) {
            return
        }

        store.context.insert(FavoriteSongDataModel(songId: String(songId.id), order: incrementOrder()))
        store.save()
    }

    func findAll() -> [SongId] {
        let descriptor = FetchDescriptor<FavoriteSongDataModel>(sortBy: [SortDescriptor(\.order)])

        return try! store.context.fetch(descriptor).map { SongId(id: UInt64($0.songId)!) }
    }

    func exists(songId: SongId) -> Bool {
        return find(songId: songId).count == 1
    }

    func update(songIds: [SongId]) {
        truncate()

        for (index, songId) in songIds.enumerated() {
            store.context.insert(FavoriteSongDataModel(songId: String(songId.id), order: index))
        }

        store.save()
    }

    func delete(songId: SongId) {
        let favoriteSongs = find(songId: songId)

        if favoriteSongs.count != 1 {
            return
        }

        favoriteSongs.forEach { store.context.delete($0) }
        store.save()
    }

    private func find(songId: SongId) -> [FavoriteSongDataModel] {
        let id = String(songId.id)
        let descriptor = FetchDescriptor<FavoriteSongDataModel>(predicate: #Predicate { $0.songId == id })

        return try! store.context.fetch(descriptor)
    }

    private func truncate() {
        let models = try! store.context.fetch(FetchDescriptor<FavoriteSongDataModel>())

        models.forEach { store.context.delete($0) }
    }

    private func incrementOrder() -> Int {
        var descriptor = FetchDescriptor<FavoriteSongDataModel>(sortBy: [SortDescriptor(\.order, order: .reverse)])

        descriptor.fetchLimit = 1

        return (try! store.context.fetch(descriptor).first?.order ?? 0) + 1
    }
}
