//
//  ShortcutRepositoryTests.swift
//  ThinMPTests
//
//  Created by tk on 2026/09/21.
//

import MediaPlayer
import Testing
@testable import ThinMP

/// ShortcutRepositoryProtocol の契約
struct ShortcutRepositoryTests {
    @Test(arguments: RepositoryBackend.allCases)
    func addWithPersistentId(backend: RepositoryBackend) {
        let repository = TestRepositories(backend: backend).shortcut
        let artistId: MPMediaEntityPersistentID = 10

        repository.add(itemId: artistId, type: .ARTIST)

        let shortcuts = repository.findAll()

        #expect(repository.exists(itemId: artistId, type: .ARTIST))
        #expect(shortcuts.count == 1)
        #expect(shortcuts[0].itemId.id == "10")
        #expect(shortcuts[0].type == .ARTIST)
    }

    @Test(arguments: RepositoryBackend.allCases)
    func addWithStringId(backend: RepositoryBackend) {
        let repository = TestRepositories(backend: backend).shortcut

        repository.add(itemId: "playlist-1", type: .PLAYLIST)

        let shortcuts = repository.findAll()

        #expect(repository.exists(itemId: "playlist-1", type: .PLAYLIST))
        #expect(shortcuts.count == 1)
        #expect(shortcuts[0].itemId.id == "playlist-1")
        #expect(shortcuts[0].type == .PLAYLIST)
    }

    @Test(arguments: RepositoryBackend.allCases)
    func addIgnoresDuplicate(backend: RepositoryBackend) {
        let repository = TestRepositories(backend: backend).shortcut

        repository.add(itemId: "1", type: .ALBUM)
        repository.add(itemId: "1", type: .ALBUM)

        #expect(repository.findAll().count == 1)
    }

    @Test(arguments: RepositoryBackend.allCases)
    func sameItemIdWithDifferentTypeIsDistinct(backend: RepositoryBackend) {
        let repository = TestRepositories(backend: backend).shortcut

        repository.add(itemId: "1", type: .ARTIST)
        repository.add(itemId: "1", type: .ALBUM)

        #expect(repository.findAll().count == 2)
        #expect(repository.exists(itemId: "1", type: .ARTIST))
        #expect(repository.exists(itemId: "1", type: .ALBUM))
        #expect(!repository.exists(itemId: "1", type: .PLAYLIST))
    }

    @Test(arguments: RepositoryBackend.allCases)
    func findAllReturnsNewestFirst(backend: RepositoryBackend) {
        let repository = TestRepositories(backend: backend).shortcut

        repository.add(itemId: "1", type: .ARTIST)
        repository.add(itemId: "2", type: .ARTIST)
        repository.add(itemId: "3", type: .ARTIST)

        #expect(repository.findAll().map { $0.itemId.id } == ["3", "2", "1"])
    }

    @Test(arguments: RepositoryBackend.allCases)
    func deleteByItemIdAndType(backend: RepositoryBackend) {
        let repository = TestRepositories(backend: backend).shortcut

        repository.add(itemId: "1", type: .ARTIST)
        repository.add(itemId: "1", type: .ALBUM)

        repository.delete(itemId: "1", type: .ARTIST)

        #expect(!repository.exists(itemId: "1", type: .ARTIST))
        #expect(repository.exists(itemId: "1", type: .ALBUM))
    }

    @Test(arguments: RepositoryBackend.allCases)
    func deleteUnknownIsNoop(backend: RepositoryBackend) {
        let repository = TestRepositories(backend: backend).shortcut

        repository.add(itemId: "1", type: .ARTIST)
        repository.delete(itemId: "99", type: .ARTIST)

        #expect(repository.findAll().count == 1)
    }

    @Test(arguments: RepositoryBackend.allCases)
    func updateDeletesMissingAndReorders(backend: RepositoryBackend) {
        let repository = TestRepositories(backend: backend).shortcut

        repository.add(itemId: "1", type: .ARTIST)
        repository.add(itemId: "2", type: .ARTIST)
        repository.add(itemId: "3", type: .ARTIST)

        let byItemId = Dictionary(uniqueKeysWithValues: repository.findAll().map { ($0.itemId.id, $0.shortcutId) })

        repository.update(shortcutIds: [byItemId["1"]!, byItemId["3"]!])

        #expect(repository.findAll().map { $0.itemId.id } == ["1", "3"])
        #expect(!repository.exists(itemId: "2", type: .ARTIST))
    }

    @Test(arguments: RepositoryBackend.allCases)
    func addAfterUpdateBecomesNewest(backend: RepositoryBackend) {
        let repository = TestRepositories(backend: backend).shortcut

        repository.add(itemId: "1", type: .ARTIST)
        repository.add(itemId: "2", type: .ARTIST)

        let byItemId = Dictionary(uniqueKeysWithValues: repository.findAll().map { ($0.itemId.id, $0.shortcutId) })

        repository.update(shortcutIds: [byItemId["1"]!, byItemId["2"]!])
        repository.add(itemId: "3", type: .ARTIST)

        #expect(repository.findAll().map { $0.itemId.id } == ["3", "1", "2"])
    }
}
