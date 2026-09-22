//
//  FavoriteSongRepository.swift
//  ThinMP
//
//  Created by tk on 2026/09/21.
//

struct FavoriteSongRepository: FavoriteSongRepositoryProtocol {
    private let favorites: FavoriteRepository<FavoriteSongDataModel>

    init(store: SwiftDataStore = .default) {
        favorites = FavoriteRepository(store: store)
    }

    func add(songId: SongId) {
        favorites.add(mediaId: String(songId.id))
    }

    /// persistentID として読めない行は落とす(ShortcutTarget と同じ扱い)
    func findAll() -> [SongId] {
        return favorites.findAll().compactMap { UInt64($0) }.map { SongId(id: $0) }
    }

    func exists(songId: SongId) -> Bool {
        return favorites.exists(mediaId: String(songId.id))
    }

    func update(songIds: [SongId]) {
        favorites.update(mediaIds: songIds.map { String($0.id) })
    }

    func delete(songId: SongId) {
        favorites.delete(mediaId: String(songId.id))
    }
}
