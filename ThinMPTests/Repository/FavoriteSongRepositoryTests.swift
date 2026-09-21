//
//  FavoriteSongRepositoryTests.swift
//  ThinMPTests
//
//  Created by tk on 2026/09/21.
//

import Testing
@testable import ThinMP

/// FavoriteSongRepositoryProtocol の契約
/// 実装(Realm / SwiftData)に依存しない振る舞いだけを検証する
struct FavoriteSongRepositoryTests {
    @Test(arguments: RepositoryBackend.allCases)
    func findAllReturnsSongsInInsertionOrder(backend: RepositoryBackend) {
        let repository = TestRepositories(backend: backend).favoriteSong

        repository.add(songId: SongId(id: 3))
        repository.add(songId: SongId(id: 1))
        repository.add(songId: SongId(id: 2))

        #expect(repository.findAll().map { $0.id } == [3, 1, 2])
    }

    @Test(arguments: RepositoryBackend.allCases)
    func addIgnoresDuplicate(backend: RepositoryBackend) {
        let repository = TestRepositories(backend: backend).favoriteSong

        repository.add(songId: SongId(id: 1))
        repository.add(songId: SongId(id: 1))

        #expect(repository.findAll().map { $0.id } == [1])
    }

    @Test(arguments: RepositoryBackend.allCases)
    func existsReflectsAddAndDelete(backend: RepositoryBackend) {
        let repository = TestRepositories(backend: backend).favoriteSong

        #expect(!repository.exists(songId: SongId(id: 1)))

        repository.add(songId: SongId(id: 1))

        #expect(repository.exists(songId: SongId(id: 1)))

        repository.delete(songId: SongId(id: 1))

        #expect(!repository.exists(songId: SongId(id: 1)))
        #expect(repository.findAll().isEmpty)
    }

    @Test(arguments: RepositoryBackend.allCases)
    func deleteUnknownSongIsNoop(backend: RepositoryBackend) {
        let repository = TestRepositories(backend: backend).favoriteSong

        repository.add(songId: SongId(id: 1))
        repository.delete(songId: SongId(id: 99))

        #expect(repository.findAll().map { $0.id } == [1])
    }

    @Test(arguments: RepositoryBackend.allCases)
    func updateReplacesAllAndReorders(backend: RepositoryBackend) {
        let repository = TestRepositories(backend: backend).favoriteSong

        repository.add(songId: SongId(id: 1))
        repository.add(songId: SongId(id: 2))
        repository.add(songId: SongId(id: 3))

        repository.update(songIds: [SongId(id: 3), SongId(id: 1)])

        #expect(repository.findAll().map { $0.id } == [3, 1])
        #expect(!repository.exists(songId: SongId(id: 2)))
    }

    @Test(arguments: RepositoryBackend.allCases)
    func updateWithEmptyClears(backend: RepositoryBackend) {
        let repository = TestRepositories(backend: backend).favoriteSong

        repository.add(songId: SongId(id: 1))
        repository.update(songIds: [])

        #expect(repository.findAll().isEmpty)
    }

    @Test(arguments: RepositoryBackend.allCases)
    func addAfterUpdateAppendsToEnd(backend: RepositoryBackend) {
        let repository = TestRepositories(backend: backend).favoriteSong

        repository.add(songId: SongId(id: 1))
        repository.add(songId: SongId(id: 2))
        repository.update(songIds: [SongId(id: 2), SongId(id: 1)])
        repository.add(songId: SongId(id: 3))

        #expect(repository.findAll().map { $0.id } == [2, 1, 3])
    }
}
