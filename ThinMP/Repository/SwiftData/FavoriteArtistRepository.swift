//
//  FavoriteArtistRepository.swift
//  ThinMP
//
//  Created by tk on 2026/09/21.
//

struct FavoriteArtistRepository: FavoriteArtistRepositoryProtocol {
    private let favorites: FavoriteRepository<FavoriteArtistDataModel>

    init(store: SwiftDataStore = .default) {
        favorites = FavoriteRepository(store: store)
    }

    /// persistentID として読めない行は落とす(ShortcutTarget と同じ扱い)
    func findAll() -> [ArtistId] {
        return favorites.findAll().compactMap { UInt64($0) }.map { ArtistId(id: $0) }
    }

    func exists(artistId: ArtistId) -> Bool {
        return favorites.exists(mediaId: String(artistId.id))
    }

    func add(artistId: ArtistId) {
        favorites.add(mediaId: String(artistId.id))
    }

    func update(artistIds: [ArtistId]) {
        favorites.update(mediaIds: artistIds.map { String($0.id) })
    }

    func delete(artistId: ArtistId) {
        favorites.delete(mediaId: String(artistId.id))
    }
}
