//
//  FavoriteArtistRepositoryTests.swift
//  ThinMPTests
//
//  Created by tk on 2026/09/21.
//

import Testing
@testable import ThinMP

/// FavoriteArtistRepositoryProtocol の契約
@MainActor
struct FavoriteArtistRepositoryTests {
    @Test(arguments: RepositoryBackend.allCases)
    func findAllReturnsArtistsInInsertionOrder(backend: RepositoryBackend) {
        let repository = TestRepositories(backend: backend).favoriteArtist

        repository.add(artistId: ArtistId(id: 3))
        repository.add(artistId: ArtistId(id: 1))
        repository.add(artistId: ArtistId(id: 2))

        #expect(repository.findAll().map { $0.id } == [3, 1, 2])
    }

    @Test(arguments: RepositoryBackend.allCases)
    func addIgnoresDuplicate(backend: RepositoryBackend) {
        let repository = TestRepositories(backend: backend).favoriteArtist

        repository.add(artistId: ArtistId(id: 1))
        repository.add(artistId: ArtistId(id: 1))

        #expect(repository.findAll().map { $0.id } == [1])
    }

    @Test(arguments: RepositoryBackend.allCases)
    func existsReflectsAddAndDelete(backend: RepositoryBackend) {
        let repository = TestRepositories(backend: backend).favoriteArtist

        #expect(!repository.exists(artistId: ArtistId(id: 1)))

        repository.add(artistId: ArtistId(id: 1))

        #expect(repository.exists(artistId: ArtistId(id: 1)))

        repository.delete(artistId: ArtistId(id: 1))

        #expect(!repository.exists(artistId: ArtistId(id: 1)))
        #expect(repository.findAll().isEmpty)
    }

    @Test(arguments: RepositoryBackend.allCases)
    func deleteUnknownArtistIsNoop(backend: RepositoryBackend) {
        let repository = TestRepositories(backend: backend).favoriteArtist

        repository.add(artistId: ArtistId(id: 1))
        repository.delete(artistId: ArtistId(id: 99))

        #expect(repository.findAll().map { $0.id } == [1])
    }

    @Test(arguments: RepositoryBackend.allCases)
    func updateReplacesAllAndReorders(backend: RepositoryBackend) {
        let repository = TestRepositories(backend: backend).favoriteArtist

        repository.add(artistId: ArtistId(id: 1))
        repository.add(artistId: ArtistId(id: 2))
        repository.add(artistId: ArtistId(id: 3))

        repository.update(artistIds: [ArtistId(id: 3), ArtistId(id: 1)])

        #expect(repository.findAll().map { $0.id } == [3, 1])
        #expect(!repository.exists(artistId: ArtistId(id: 2)))
    }

    @Test(arguments: RepositoryBackend.allCases)
    func updateWithEmptyClears(backend: RepositoryBackend) {
        let repository = TestRepositories(backend: backend).favoriteArtist

        repository.add(artistId: ArtistId(id: 1))
        repository.update(artistIds: [])

        #expect(repository.findAll().isEmpty)
    }

    @Test(arguments: RepositoryBackend.allCases)
    func addAfterUpdateAppendsToEnd(backend: RepositoryBackend) {
        let repository = TestRepositories(backend: backend).favoriteArtist

        repository.add(artistId: ArtistId(id: 1))
        repository.add(artistId: ArtistId(id: 2))
        repository.update(artistIds: [ArtistId(id: 2), ArtistId(id: 1)])
        repository.add(artistId: ArtistId(id: 3))

        #expect(repository.findAll().map { $0.id } == [2, 1, 3])
    }
}
