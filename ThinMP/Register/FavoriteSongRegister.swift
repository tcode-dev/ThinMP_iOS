//
//  FavoriteSongRegister.swift
//  ThinMP
//
//  Created by tk on 2021/02/20.
//

struct FavoriteSongRegister: FavoriteSongRegisterProtocol {
    private let repository: FavoriteSongRepositoryProtocol

    init(repository: FavoriteSongRepositoryProtocol = FavoriteSongRepository()) {
        self.repository = repository
    }

    func add(songId: SongId) {
        repository.add(songId: songId)
    }

    func exists(songId: SongId) -> Bool {
        return repository.exists(songId: songId)
    }

    func update(songIds: [SongId]) {
        repository.update(songIds: songIds)
    }

    func delete(songId: SongId) {
        repository.delete(songId: songId)
    }
}
