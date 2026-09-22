//
//  ShortcutRepositoryTests.swift
//  ThinMPTests
//
//  Created by tk on 2026/09/21.
//

import RealmSwift
import SwiftData
import Testing
@testable import ThinMP

/// ShortcutRepositoryProtocol の契約
@MainActor
struct ShortcutRepositoryTests {
    @Test(arguments: RepositoryBackend.allCases)
    func addStoresTarget(backend: RepositoryBackend) {
        let repository = TestRepositories(backend: backend).shortcut
        let target = ShortcutTarget.playlist(PlaylistId(id: "playlist-1"))

        repository.add(target: target)

        let shortcuts = repository.findAll()

        #expect(repository.exists(target: target))
        #expect(shortcuts.count == 1)
        #expect(shortcuts[0].target == target)
    }

    @Test(arguments: RepositoryBackend.allCases)
    func addIgnoresDuplicate(backend: RepositoryBackend) {
        let repository = TestRepositories(backend: backend).shortcut

        repository.add(target: .album(AlbumId(id: 1)))
        repository.add(target: .album(AlbumId(id: 1)))

        #expect(repository.findAll().count == 1)
    }

    @Test(arguments: RepositoryBackend.allCases)
    func sameIdWithDifferentTypeIsDistinct(backend: RepositoryBackend) {
        let repository = TestRepositories(backend: backend).shortcut

        repository.add(target: .artist(ArtistId(id: 1)))
        repository.add(target: .album(AlbumId(id: 1)))

        #expect(repository.findAll().count == 2)
        #expect(repository.exists(target: .artist(ArtistId(id: 1))))
        #expect(repository.exists(target: .album(AlbumId(id: 1))))
        #expect(!repository.exists(target: .playlist(PlaylistId(id: "1"))))
    }

    @Test(arguments: RepositoryBackend.allCases)
    func findAllReturnsNewestFirst(backend: RepositoryBackend) {
        let repository = TestRepositories(backend: backend).shortcut

        repository.add(target: .artist(ArtistId(id: 1)))
        repository.add(target: .artist(ArtistId(id: 2)))
        repository.add(target: .artist(ArtistId(id: 3)))

        #expect(repository.findAll().map { $0.target } == [.artist(ArtistId(id: 3)), .artist(ArtistId(id: 2)), .artist(ArtistId(id: 1))])
    }

    @Test(arguments: RepositoryBackend.allCases)
    func deleteByTarget(backend: RepositoryBackend) {
        let repository = TestRepositories(backend: backend).shortcut

        repository.add(target: .artist(ArtistId(id: 1)))
        repository.add(target: .album(AlbumId(id: 1)))

        repository.delete(target: .artist(ArtistId(id: 1)))

        #expect(!repository.exists(target: .artist(ArtistId(id: 1))))
        #expect(repository.exists(target: .album(AlbumId(id: 1))))
    }

    @Test(arguments: RepositoryBackend.allCases)
    func deleteUnknownIsNoop(backend: RepositoryBackend) {
        let repository = TestRepositories(backend: backend).shortcut

        repository.add(target: .artist(ArtistId(id: 1)))
        repository.delete(target: .artist(ArtistId(id: 99)))

        #expect(repository.findAll().count == 1)
    }

    @Test(arguments: RepositoryBackend.allCases)
    func updateDeletesMissingAndReorders(backend: RepositoryBackend) {
        let repository = TestRepositories(backend: backend).shortcut

        repository.add(target: .artist(ArtistId(id: 1)))
        repository.add(target: .artist(ArtistId(id: 2)))
        repository.add(target: .artist(ArtistId(id: 3)))

        let byTarget = Dictionary(uniqueKeysWithValues: repository.findAll().map { ($0.target, $0.shortcutId) })

        repository.update(shortcutIds: [byTarget[.artist(ArtistId(id: 1))]!, byTarget[.artist(ArtistId(id: 3))]!])

        #expect(repository.findAll().map { $0.target } == [.artist(ArtistId(id: 1)), .artist(ArtistId(id: 3))])
        #expect(!repository.exists(target: .artist(ArtistId(id: 2))))
    }

    @Test(arguments: RepositoryBackend.allCases)
    func addAfterUpdateBecomesNewest(backend: RepositoryBackend) {
        let repository = TestRepositories(backend: backend).shortcut

        repository.add(target: .artist(ArtistId(id: 1)))
        repository.add(target: .artist(ArtistId(id: 2)))

        let byTarget = Dictionary(uniqueKeysWithValues: repository.findAll().map { ($0.target, $0.shortcutId) })

        repository.update(shortcutIds: [byTarget[.artist(ArtistId(id: 1))]!, byTarget[.artist(ArtistId(id: 2))]!])
        repository.add(target: .artist(ArtistId(id: 3)))

        #expect(repository.findAll().map { $0.target } == [.artist(ArtistId(id: 3)), .artist(ArtistId(id: 1)), .artist(ArtistId(id: 2))])
    }

    /// ストアに同じショートカットが 2 行残っていても(Repository は防いでいるが)、exists は true、delete は全部消す
    @Test(arguments: RepositoryBackend.allCases)
    func existsAndDeleteToleratesDuplicateRows(backend: RepositoryBackend) {
        let repositories = TestRepositories(backend: backend)
        let repository = repositories.shortcut
        let target = ShortcutTarget.artist(ArtistId(id: 1))

        repositories.writeDirectly(realm: { realm in
            for order in 1 ... 2 {
                let model = ShortcutRealmModel()

                model.itemId = target.itemId
                model.type = target.type.rawValue
                model.order = order
                realm.add(model)
            }
        }, swiftData: { context in
            for order in 1 ... 2 {
                context.insert(ShortcutDataModel(itemId: target.itemId, type: target.type, order: order))
            }
        })

        #expect(repository.exists(target: target))

        repository.delete(target: target)

        #expect(!repository.exists(target: target))
        #expect(repository.findAll().isEmpty)
    }

    /// アーティスト / アルバムの itemId が persistentID として読めない行は findAll から落ちる(ShortcutTarget に変換できないため)
    @Test(arguments: RepositoryBackend.allCases)
    func findAllSkipsRowsWhoseItemIdIsNotAPersistentId(backend: RepositoryBackend) {
        let repositories = TestRepositories(backend: backend)
        let repository = repositories.shortcut

        repository.add(target: .artist(ArtistId(id: 1)))
        repository.add(target: .playlist(PlaylistId(id: "not-a-number")))
        repositories.writeDirectly(realm: { realm in
            let model = ShortcutRealmModel()

            model.itemId = "broken"
            model.type = ShortcutType.album.rawValue
            model.order = 99
            realm.add(model)
        }, swiftData: { context in
            context.insert(ShortcutDataModel(itemId: "broken", type: .album, order: 99))
        })

        #expect(repository.findAll().map { $0.target } == [.playlist(PlaylistId(id: "not-a-number")), .artist(ArtistId(id: 1))])
    }
}
