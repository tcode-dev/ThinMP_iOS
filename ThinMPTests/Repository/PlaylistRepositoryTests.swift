//
//  PlaylistRepositoryTests.swift
//  ThinMPTests
//
//  Created by tk on 2026/09/21.
//

import Foundation
import SwiftData
import Testing
@testable import ThinMP

/// PlaylistRepositoryProtocol の契約
struct PlaylistRepositoryTests {
    @Test(arguments: RepositoryBackend.allCases)
    func createStoresNameAndFirstSong(backend: RepositoryBackend) {
        let repository = TestRepositories(backend: backend).playlist

        repository.create(songId: SongId(id: 1), name: "A")

        let playlists = repository.findAll()

        #expect(playlists.count == 1)
        #expect(playlists[0].name == "A")
        #expect(playlists[0].songIds.map { $0.id } == [1])
    }

    @Test(arguments: RepositoryBackend.allCases)
    func findAllReturnsPlaylistsInCreationOrder(backend: RepositoryBackend) {
        let repository = TestRepositories(backend: backend).playlist

        repository.create(songId: SongId(id: 1), name: "A")
        repository.create(songId: SongId(id: 1), name: "B")
        repository.create(songId: SongId(id: 1), name: "C")

        #expect(repository.findAll().map { $0.name } == ["A", "B", "C"])
    }

    @Test(arguments: RepositoryBackend.allCases)
    func addAppendsSongToEnd(backend: RepositoryBackend) {
        let repository = TestRepositories(backend: backend).playlist

        repository.create(songId: SongId(id: 1), name: "A")

        let playlistId = repository.findAll()[0].playlistId

        repository.add(playlistId: playlistId, songId: SongId(id: 3))
        repository.add(playlistId: playlistId, songId: SongId(id: 2))

        #expect(repository.findById(playlistId: playlistId).songIds.map { $0.id } == [1, 3, 2])
    }

    @Test(arguments: RepositoryBackend.allCases)
    func addIgnoresSongAlreadyInPlaylist(backend: RepositoryBackend) {
        let repository = TestRepositories(backend: backend).playlist

        repository.create(songId: SongId(id: 1), name: "A")

        let playlistId = repository.findAll()[0].playlistId

        repository.add(playlistId: playlistId, songId: SongId(id: 2))
        repository.add(playlistId: playlistId, songId: SongId(id: 1))
        repository.add(playlistId: playlistId, songId: SongId(id: 2))

        #expect(repository.findById(playlistId: playlistId).songIds.map { $0.id } == [1, 2])
    }

    @Test(arguments: RepositoryBackend.allCases)
    func findByIdsReturnsOnlyMatching(backend: RepositoryBackend) {
        let repository = TestRepositories(backend: backend).playlist

        repository.create(songId: SongId(id: 1), name: "A")
        repository.create(songId: SongId(id: 1), name: "B")
        repository.create(songId: SongId(id: 1), name: "C")

        let all = repository.findAll()
        let found = repository.findByIds(playlistIds: [all[0].playlistId, all[2].playlistId, PlaylistId(id: "unknown")])

        #expect(Set(found.map { $0.name }) == ["A", "C"])
    }

    @Test(arguments: RepositoryBackend.allCases)
    func updateReplacesNameAndSongs(backend: RepositoryBackend) {
        let repository = TestRepositories(backend: backend).playlist

        repository.create(songId: SongId(id: 1), name: "A")

        let playlistId = repository.findAll()[0].playlistId

        repository.add(playlistId: playlistId, songId: SongId(id: 2))
        repository.update(playlistId: playlistId, name: "Z", songIds: [SongId(id: 3), SongId(id: 1)])

        let playlist = repository.findById(playlistId: playlistId)

        #expect(playlist.name == "Z")
        #expect(playlist.songIds.map { $0.id } == [3, 1])
    }

    @Test(arguments: RepositoryBackend.allCases)
    func updateKeepsOnlyFirstOccurrenceOfDuplicateSongs(backend: RepositoryBackend) {
        let repository = TestRepositories(backend: backend).playlist

        repository.create(songId: SongId(id: 1), name: "A")

        let playlistId = repository.findAll()[0].playlistId

        repository.update(playlistId: playlistId, name: "A", songIds: [SongId(id: 2), SongId(id: 1), SongId(id: 2), SongId(id: 3), SongId(id: 1)])

        #expect(repository.findById(playlistId: playlistId).songIds.map { $0.id } == [2, 1, 3])
    }

    /// SwiftData ストア自体の制約。Repository を経由せずに重複を insert しても 1 行にまとまる
    @Test
    func swiftDataStoreRejectsDuplicateSongInSamePlaylist() {
        let store = SwiftDataStore.inMemory()
        let repository = PlaylistRepository(store: store)

        repository.create(songId: SongId(id: 1), name: "A")
        repository.create(songId: SongId(id: 1), name: "B")

        let playlistId = repository.findAll()[0].playlistId
        let id = playlistId.id
        let playlist = try! store.context.fetch(FetchDescriptor<PlaylistDataModel>(predicate: #Predicate { $0.id == id })).first!
        let duplicate = PlaylistSongDataModel(playlistId: playlist.id, songId: "1", order: 1)

        store.context.insert(duplicate)
        playlist.songs.append(duplicate)
        store.save()

        let songs = try! store.context.fetch(FetchDescriptor<PlaylistSongDataModel>(predicate: #Predicate { $0.playlistId == id }))

        #expect(songs.count == 1)
        #expect(repository.findById(playlistId: playlistId).songIds.map { $0.id } == [1])
        // 別のプレイリストの同じ曲には影響しない
        #expect(repository.findAll()[1].songIds.map { $0.id } == [1])
    }

    @Test(arguments: RepositoryBackend.allCases)
    func updateWithEmptySongsKeepsPlaylist(backend: RepositoryBackend) {
        let repository = TestRepositories(backend: backend).playlist

        repository.create(songId: SongId(id: 1), name: "A")

        let playlistId = repository.findAll()[0].playlistId

        repository.update(playlistId: playlistId, name: "A", songIds: [])

        #expect(repository.findById(playlistId: playlistId).songIds.isEmpty)
        #expect(repository.findAll().count == 1)
    }

    @Test(arguments: RepositoryBackend.allCases)
    func updateOrderDeletesMissingAndReorders(backend: RepositoryBackend) {
        let repository = TestRepositories(backend: backend).playlist

        repository.create(songId: SongId(id: 1), name: "A")
        repository.create(songId: SongId(id: 1), name: "B")
        repository.create(songId: SongId(id: 1), name: "C")

        let all = repository.findAll()
        let a = all[0].playlistId
        let b = all[1].playlistId
        let c = all[2].playlistId

        repository.update(playlistIds: [c, a])

        #expect(repository.findAll().map { $0.name } == ["C", "A"])
        #expect(repository.findByIds(playlistIds: [b]).isEmpty)
    }

    @Test(arguments: RepositoryBackend.allCases)
    func deleteRemovesPlaylist(backend: RepositoryBackend) {
        let repository = TestRepositories(backend: backend).playlist

        repository.create(songId: SongId(id: 1), name: "A")
        repository.create(songId: SongId(id: 1), name: "B")

        let a = repository.findAll()[0].playlistId

        repository.delete(playlistId: a)

        #expect(repository.findAll().map { $0.name } == ["B"])
    }

    @Test(arguments: RepositoryBackend.allCases)
    func createAfterReorderAppendsToEnd(backend: RepositoryBackend) {
        let repository = TestRepositories(backend: backend).playlist

        repository.create(songId: SongId(id: 1), name: "A")
        repository.create(songId: SongId(id: 1), name: "B")

        let all = repository.findAll()

        repository.update(playlistIds: [all[1].playlistId, all[0].playlistId])
        repository.create(songId: SongId(id: 1), name: "C")

        #expect(repository.findAll().map { $0.name } == ["B", "A", "C"])
    }
}
