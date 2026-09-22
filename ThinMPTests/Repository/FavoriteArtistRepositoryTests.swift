//
//  FavoriteArtistRepositoryTests.swift
//  ThinMPTests
//
//  Created by tk on 2026/09/21.
//

import RealmSwift
import SwiftData
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

    /// ストアに同じアーティストが 2 行残っていても(Repository は防いでいるが)、exists は true、delete は全部消す
    @Test(arguments: RepositoryBackend.allCases)
    func existsAndDeleteToleratesDuplicateRows(backend: RepositoryBackend) {
        let repositories = TestRepositories(backend: backend)
        let repository = repositories.favoriteArtist

        repositories.writeDirectly(realm: { realm in
            for order in 1 ... 2 {
                let model = FavoriteArtistRealmModel()

                model.artistId = "1"
                model.order = order
                realm.add(model)
            }
        }, swiftData: { context in
            for order in 1 ... 2 {
                context.insert(FavoriteArtistDataModel(artistId: "1", order: order))
            }
        })

        #expect(repository.exists(artistId: ArtistId(id: 1)))

        repository.delete(artistId: ArtistId(id: 1))

        #expect(!repository.exists(artistId: ArtistId(id: 1)))
        #expect(repository.findAll().isEmpty)
    }

    @Test(arguments: RepositoryBackend.allCases)
    func toggleAddsThenRemoves(backend: RepositoryBackend) {
        let repository = TestRepositories(backend: backend).favoriteArtist

        #expect(repository.toggle(artistId: ArtistId(id: 1)))
        #expect(repository.exists(artistId: ArtistId(id: 1)))

        #expect(!repository.toggle(artistId: ArtistId(id: 1)))
        #expect(!repository.exists(artistId: ArtistId(id: 1)))
    }
}

/// persistentID として読めない行が残っていても findAll が落ちないこと
/// SwiftData だけを見る。Realm 側は force unwrap のままで、削除予定なので触っていない
@MainActor
struct FavoriteRepositoryBrokenRowTests {
    @Test
    func favoriteArtistsSkipRowsWhoseIdIsNotAPersistentId() {
        let repositories = TestRepositories(backend: .swiftData)
        let repository = repositories.favoriteArtist

        repository.add(artistId: ArtistId(id: 1))
        repositories.writeDirectly(realm: { _ in }, swiftData: { context in
            context.insert(FavoriteArtistDataModel(artistId: "broken", order: 99))
        })

        #expect(repository.findAll().map { $0.id } == [1])
    }

    @Test
    func favoriteSongsSkipRowsWhoseIdIsNotAPersistentId() {
        let repositories = TestRepositories(backend: .swiftData)
        let repository = repositories.favoriteSong

        repository.add(songId: SongId(id: 1))
        repositories.writeDirectly(realm: { _ in }, swiftData: { context in
            context.insert(FavoriteSongDataModel(songId: "broken", order: 99))
        })

        #expect(repository.findAll().map { $0.id } == [1])
    }

    @Test
    func playlistSongsSkipRowsWhoseIdIsNotAPersistentId() {
        let repositories = TestRepositories(backend: .swiftData)
        let repository = repositories.playlist

        repository.create(songId: SongId(id: 1), name: "P")

        let playlistId = repository.findAll()[0].playlistId

        repositories.writeDirectly(realm: { _ in }, swiftData: { context in
            let song = PlaylistSongDataModel(playlistId: playlistId.id, songId: "broken", order: 99)

            context.insert(song)
            // リレーションに繋がないと sortedSongs に出てこないので、Repository を通さずに繋ぐ
            try! context.fetch(FetchDescriptor<PlaylistDataModel>()).first?.songs.append(song)
        })

        #expect(repository.findById(playlistId: playlistId)?.songIds.map { $0.id } == [1])
    }
}
