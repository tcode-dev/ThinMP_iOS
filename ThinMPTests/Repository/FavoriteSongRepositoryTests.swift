//
//  FavoriteSongRepositoryTests.swift
//  ThinMPTests
//
//  Created by tk on 2026/09/21.
//

import RealmSwift
import SwiftData
import Testing
@testable import ThinMP

/// FavoriteSongRepositoryProtocol の契約
/// 実装(Realm / SwiftData)に依存しない振る舞いだけを検証する
@MainActor
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

    /// ストアに同じ曲が 2 行残っていても(Repository は防いでいるが)、exists は true、delete は全部消す
    @Test(arguments: RepositoryBackend.allCases)
    func existsAndDeleteToleratesDuplicateRows(backend: RepositoryBackend) {
        let repositories = TestRepositories(backend: backend)
        let repository = repositories.favoriteSong

        repositories.writeDirectly(realm: { realm in
            for order in 1 ... 2 {
                let model = FavoriteSongRealmModel()

                model.songId = "1"
                model.order = order
                realm.add(model)
            }
        }, swiftData: { context in
            for order in 1 ... 2 {
                context.insert(FavoriteSongDataModel(songId: "1", order: order))
            }
        })

        #expect(repository.exists(songId: SongId(id: 1)))

        repository.delete(songId: SongId(id: 1))

        #expect(!repository.exists(songId: SongId(id: 1)))
        #expect(repository.findAll().isEmpty)
    }

    @Test(arguments: RepositoryBackend.allCases)
    func toggleAddsThenRemoves(backend: RepositoryBackend) {
        let repository = TestRepositories(backend: backend).favoriteSong

        #expect(repository.toggle(songId: SongId(id: 1)))
        #expect(repository.exists(songId: SongId(id: 1)))

        #expect(!repository.toggle(songId: SongId(id: 1)))
        #expect(!repository.exists(songId: SongId(id: 1)))
    }

    /// songId が persistentID として読めない行は findAll から落ちる
    /// SwiftData だけを見る。Realm 側は force unwrap のままで、削除予定なので触っていない
    @Test
    func findAllSkipsRowsWhoseIdIsNotAPersistentId() {
        let repositories = TestRepositories(backend: .swiftData)
        let repository = repositories.favoriteSong

        repository.add(songId: SongId(id: 1))
        repositories.writeDirectly(realm: { _ in }, swiftData: { context in
            context.insert(FavoriteSongDataModel(songId: "broken", order: 99))
        })

        #expect(repository.findAll().map { $0.id } == [1])
    }

    /// ストアに同じ曲の行が残っていても、findAll は最初の 1 回だけ返す
    /// SwiftData だけを見る。Realm 側は削除予定なので触っていない
    @Test
    func findAllReturnsDuplicateRowsOnce() {
        let repositories = TestRepositories(backend: .swiftData)
        let repository = repositories.favoriteSong

        repositories.writeDirectly(realm: { _ in }, swiftData: { context in
            context.insert(FavoriteSongDataModel(songId: "1", order: 0))
            context.insert(FavoriteSongDataModel(songId: "2", order: 1))
            context.insert(FavoriteSongDataModel(songId: "1", order: 2))
        })

        #expect(repository.findAll().map { $0.id } == [1, 2])
    }

    /// 同じ曲を 2 回渡しても、最初の位置に 1 行だけ残す
    /// SwiftData だけを見る。Realm 側は削除予定なので触っていない
    @Test
    func updateKeepsOnlyFirstOccurrenceOfDuplicates() throws {
        let store = SwiftDataStore.inMemory()
        let repository = TestRepositories(backend: .swiftData, swiftDataStore: store).favoriteSong

        repository.update(songIds: [SongId(id: 2), SongId(id: 1), SongId(id: 2)])

        #expect(repository.findAll().map { $0.id } == [2, 1])
        #expect(try store.context.fetchCount(FetchDescriptor<FavoriteSongDataModel>()) == 2)
    }
}
