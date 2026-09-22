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
    func addStoresItemIdAndType(backend: RepositoryBackend) {
        let repository = TestRepositories(backend: backend).shortcut
        let itemId = ItemId(id: "playlist-1")

        repository.add(itemId: itemId, type: .playlist)

        let shortcuts = repository.findAll()

        #expect(repository.exists(itemId: itemId, type: .playlist))
        #expect(shortcuts.count == 1)
        #expect(shortcuts[0].itemId == itemId)
        #expect(shortcuts[0].type == .playlist)
    }

    @Test(arguments: RepositoryBackend.allCases)
    func addIgnoresDuplicate(backend: RepositoryBackend) {
        let repository = TestRepositories(backend: backend).shortcut

        repository.add(itemId: ItemId(id: "1"), type: .album)
        repository.add(itemId: ItemId(id: "1"), type: .album)

        #expect(repository.findAll().count == 1)
    }

    @Test(arguments: RepositoryBackend.allCases)
    func sameItemIdWithDifferentTypeIsDistinct(backend: RepositoryBackend) {
        let repository = TestRepositories(backend: backend).shortcut

        repository.add(itemId: ItemId(id: "1"), type: .artist)
        repository.add(itemId: ItemId(id: "1"), type: .album)

        #expect(repository.findAll().count == 2)
        #expect(repository.exists(itemId: ItemId(id: "1"), type: .artist))
        #expect(repository.exists(itemId: ItemId(id: "1"), type: .album))
        #expect(!repository.exists(itemId: ItemId(id: "1"), type: .playlist))
    }

    @Test(arguments: RepositoryBackend.allCases)
    func findAllReturnsNewestFirst(backend: RepositoryBackend) {
        let repository = TestRepositories(backend: backend).shortcut

        repository.add(itemId: ItemId(id: "1"), type: .artist)
        repository.add(itemId: ItemId(id: "2"), type: .artist)
        repository.add(itemId: ItemId(id: "3"), type: .artist)

        #expect(repository.findAll().map { $0.itemId.id } == ["3", "2", "1"])
    }

    @Test(arguments: RepositoryBackend.allCases)
    func deleteByItemIdAndType(backend: RepositoryBackend) {
        let repository = TestRepositories(backend: backend).shortcut

        repository.add(itemId: ItemId(id: "1"), type: .artist)
        repository.add(itemId: ItemId(id: "1"), type: .album)

        repository.delete(itemId: ItemId(id: "1"), type: .artist)

        #expect(!repository.exists(itemId: ItemId(id: "1"), type: .artist))
        #expect(repository.exists(itemId: ItemId(id: "1"), type: .album))
    }

    @Test(arguments: RepositoryBackend.allCases)
    func deleteUnknownIsNoop(backend: RepositoryBackend) {
        let repository = TestRepositories(backend: backend).shortcut

        repository.add(itemId: ItemId(id: "1"), type: .artist)
        repository.delete(itemId: ItemId(id: "99"), type: .artist)

        #expect(repository.findAll().count == 1)
    }

    @Test(arguments: RepositoryBackend.allCases)
    func updateDeletesMissingAndReorders(backend: RepositoryBackend) {
        let repository = TestRepositories(backend: backend).shortcut

        repository.add(itemId: ItemId(id: "1"), type: .artist)
        repository.add(itemId: ItemId(id: "2"), type: .artist)
        repository.add(itemId: ItemId(id: "3"), type: .artist)

        let byItemId = Dictionary(uniqueKeysWithValues: repository.findAll().map { ($0.itemId.id, $0.shortcutId) })

        repository.update(shortcutIds: [byItemId["1"]!, byItemId["3"]!])

        #expect(repository.findAll().map { $0.itemId.id } == ["1", "3"])
        #expect(!repository.exists(itemId: ItemId(id: "2"), type: .artist))
    }

    @Test(arguments: RepositoryBackend.allCases)
    func addAfterUpdateBecomesNewest(backend: RepositoryBackend) {
        let repository = TestRepositories(backend: backend).shortcut

        repository.add(itemId: ItemId(id: "1"), type: .artist)
        repository.add(itemId: ItemId(id: "2"), type: .artist)

        let byItemId = Dictionary(uniqueKeysWithValues: repository.findAll().map { ($0.itemId.id, $0.shortcutId) })

        repository.update(shortcutIds: [byItemId["1"]!, byItemId["2"]!])
        repository.add(itemId: ItemId(id: "3"), type: .artist)

        #expect(repository.findAll().map { $0.itemId.id } == ["3", "1", "2"])
    }

    /// ストアに同じショートカットが 2 行残っていても(Repository は防いでいるが)、exists は true、delete は全部消す
    @Test(arguments: RepositoryBackend.allCases)
    func existsAndDeleteToleratesDuplicateRows(backend: RepositoryBackend) {
        let repositories = TestRepositories(backend: backend)
        let repository = repositories.shortcut
        let itemId = ItemId(id: "1")

        repositories.writeDirectly(realm: { realm in
            for order in 1 ... 2 {
                let model = ShortcutRealmModel()

                model.itemId = itemId.id
                model.type = ShortcutType.artist.rawValue
                model.order = order
                realm.add(model)
            }
        }, swiftData: { context in
            for order in 1 ... 2 {
                context.insert(ShortcutDataModel(itemId: itemId.id, type: .artist, order: order))
            }
        })

        #expect(repository.exists(itemId: itemId, type: .artist))

        repository.delete(itemId: itemId, type: .artist)

        #expect(!repository.exists(itemId: itemId, type: .artist))
        #expect(repository.findAll().isEmpty)
    }

    /// アーティスト / アルバムの itemId が persistentID として読めない行は findAll から落ちる(ItemId.artistId で落ちないように)
    @Test(arguments: RepositoryBackend.allCases)
    func findAllSkipsRowsWhoseItemIdIsNotAPersistentId(backend: RepositoryBackend) {
        let repositories = TestRepositories(backend: backend)
        let repository = repositories.shortcut

        repository.add(itemId: ItemId(id: "1"), type: .artist)
        repository.add(itemId: ItemId(id: "not-a-number"), type: .playlist)
        repositories.writeDirectly(realm: { realm in
            let model = ShortcutRealmModel()

            model.itemId = "broken"
            model.type = ShortcutType.album.rawValue
            model.order = 99
            realm.add(model)
        }, swiftData: { context in
            context.insert(ShortcutDataModel(itemId: "broken", type: .album, order: 99))
        })

        #expect(repository.findAll().map { $0.itemId.id } == ["not-a-number", "1"])
    }
}
