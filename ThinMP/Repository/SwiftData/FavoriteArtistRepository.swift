//
//  FavoriteArtistRepository.swift
//  ThinMP
//
//  Created by tk on 2026/09/21.
//

import Foundation
import SwiftData

struct FavoriteArtistRepository: FavoriteArtistRepositoryProtocol {
    private let store: SwiftDataStore

    init(store: SwiftDataStore = .default) {
        self.store = store
    }

    func findAll() -> [ArtistId] {
        let descriptor = FetchDescriptor<FavoriteArtistDataModel>(sortBy: [SortDescriptor(\.order)])

        return try! store.context.fetch(descriptor).map { ArtistId(id: UInt64($0.artistId)!) }
    }

    func exists(artistId: ArtistId) -> Bool {
        return !find(artistId: artistId).isEmpty
    }

    func add(artistId: ArtistId) {
        if exists(artistId: artistId) {
            return
        }

        store.context.insert(FavoriteArtistDataModel(artistId: String(artistId.id), order: incrementOrder()))
        store.save()
    }

    func update(artistIds: [ArtistId]) {
        truncate()

        for (index, artistId) in artistIds.enumerated() {
            store.context.insert(FavoriteArtistDataModel(artistId: String(artistId.id), order: index))
        }

        store.save()
    }

    func delete(artistId: ArtistId) {
        let favoriteArtists = find(artistId: artistId)

        if favoriteArtists.isEmpty {
            return
        }

        favoriteArtists.forEach { store.context.delete($0) }
        store.save()
    }

    private func find(artistId: ArtistId) -> [FavoriteArtistDataModel] {
        let id = String(artistId.id)
        let descriptor = FetchDescriptor<FavoriteArtistDataModel>(predicate: #Predicate { $0.artistId == id })

        return try! store.context.fetch(descriptor)
    }

    private func truncate() {
        let models = try! store.context.fetch(FetchDescriptor<FavoriteArtistDataModel>())

        models.forEach { store.context.delete($0) }
    }

    private func incrementOrder() -> Int {
        var descriptor = FetchDescriptor<FavoriteArtistDataModel>(sortBy: [SortDescriptor(\.order, order: .reverse)])

        descriptor.fetchLimit = 1

        return (try! store.context.fetch(descriptor).first?.order ?? 0) + 1
    }
}
