//
//  RealmToSwiftDataMigrationTests.swift
//  ThinMPTests
//
//  Created by tk on 2026/09/21.
//

import Foundation
import Testing
@testable import ThinMP

private final class TestBundleToken {}

struct RealmToSwiftDataMigrationTests {
    /// テストごとに独立した一時ディレクトリと UserDefaults
    private struct Sandbox {
        let directory: URL
        let userDefaults: UserDefaults
        let suiteName: String

        init() {
            suiteName = "ThinMPTests.\(UUID().uuidString)"
            directory = FileManager.default.temporaryDirectory.appendingPathComponent(suiteName, isDirectory: true)
            try! FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
            userDefaults = UserDefaults(suiteName: suiteName)!
        }

        var realmURL: URL {
            return directory.appendingPathComponent(LegacyRealmFixture.fileName)
        }

        func copyFixture() {
            let bundled = Bundle(for: TestBundleToken.self).url(forResource: "legacy", withExtension: "realm")!

            try! FileManager.default.copyItem(at: bundled, to: realmURL)
        }

        func cleanup() {
            userDefaults.removePersistentDomain(forName: suiteName)
            try? FileManager.default.removeItem(at: directory)
        }
    }

    @Test
    func migrateCopiesEverythingFromInMemoryRealm() {
        let realmStore = RealmStore.inMemory()
        let swiftDataStore = SwiftDataStore.inMemory()
        let realm = TestRepositories(backend: .realm, realmStore: realmStore)
        let swiftData = TestRepositories(backend: .swiftData, swiftDataStore: swiftDataStore)

        LegacyRealmFixture.populate(realm)

        RealmToSwiftDataMigration(realmStore: realmStore, swiftDataStore: swiftDataStore, userDefaults: .standard).migrate()

        LegacyRealmFixture.verify(swiftData)
        // PlaylistId は引き継がれる
        #expect(swiftData.playlist.findAll().map { $0.playlistId.id } == realm.playlist.findAll().map { $0.playlistId.id })
    }

    @Test
    func migrateIfNeededMigratesFixtureFileThenDeletesIt() {
        let sandbox = Sandbox()
        defer { sandbox.cleanup() }

        sandbox.copyFixture()

        let swiftDataStore = SwiftDataStore.inMemory()
        let migration = RealmToSwiftDataMigration(realmStore: .file(url: sandbox.realmURL), swiftDataStore: swiftDataStore, userDefaults: sandbox.userDefaults)

        migration.migrateIfNeeded()

        LegacyRealmFixture.verify(TestRepositories(backend: .swiftData, swiftDataStore: swiftDataStore))
        #expect(sandbox.userDefaults.bool(forKey: RealmToSwiftDataMigration.migratedKey))
        #expect(!FileManager.default.fileExists(atPath: sandbox.realmURL.path))
    }

    @Test
    func migrateIfNeededWithoutRealmFileMarksMigrated() {
        let sandbox = Sandbox()
        defer { sandbox.cleanup() }

        let swiftDataStore = SwiftDataStore.inMemory()
        let migration = RealmToSwiftDataMigration(realmStore: .file(url: sandbox.realmURL), swiftDataStore: swiftDataStore, userDefaults: sandbox.userDefaults)

        migration.migrateIfNeeded()

        #expect(sandbox.userDefaults.bool(forKey: RealmToSwiftDataMigration.migratedKey))
        #expect(FavoriteSongRepository(store: swiftDataStore).findAll().isEmpty)
        // Realm を開いていないのでファイルは作られない
        #expect(!FileManager.default.fileExists(atPath: sandbox.realmURL.path))
    }

    @Test
    func migrateIfNeededSkipsWhenAlreadyMigrated() {
        let sandbox = Sandbox()
        defer { sandbox.cleanup() }

        sandbox.copyFixture()
        sandbox.userDefaults.set(true, forKey: RealmToSwiftDataMigration.migratedKey)

        let swiftDataStore = SwiftDataStore.inMemory()
        let migration = RealmToSwiftDataMigration(realmStore: .file(url: sandbox.realmURL), swiftDataStore: swiftDataStore, userDefaults: sandbox.userDefaults)

        migration.migrateIfNeeded()

        #expect(FavoriteSongRepository(store: swiftDataStore).findAll().isEmpty)
        #expect(FileManager.default.fileExists(atPath: sandbox.realmURL.path))
    }

    @Test
    func migrateIfNeededDoesNotDuplicateWhenSwiftDataAlreadyHasData() {
        let sandbox = Sandbox()
        defer { sandbox.cleanup() }

        sandbox.copyFixture()

        let swiftDataStore = SwiftDataStore.inMemory()
        let favoriteSongRepository = FavoriteSongRepository(store: swiftDataStore)

        // 前回の起動でコピーは終わったがファイル削除まで到達しなかった状態
        favoriteSongRepository.add(songId: SongId(id: 999))

        let migration = RealmToSwiftDataMigration(realmStore: .file(url: sandbox.realmURL), swiftDataStore: swiftDataStore, userDefaults: sandbox.userDefaults)

        migration.migrateIfNeeded()

        #expect(favoriteSongRepository.findAll().map { $0.id } == [999])
        #expect(sandbox.userDefaults.bool(forKey: RealmToSwiftDataMigration.migratedKey))
        #expect(!FileManager.default.fileExists(atPath: sandbox.realmURL.path))
    }

    /// Fixtures/legacy.realm を作り直すときだけ有効にする
    /// 出力先はリポジトリ内の ThinMPTests/Fixtures。生成後に .lock / .note / .management は削除すること
    @Test(.disabled("fixture generator"))
    func generateLegacyRealmFixture() {
        let url = URL(fileURLWithPath: #filePath)
            .deletingLastPathComponent()
            .deletingLastPathComponent()
            .appendingPathComponent("Fixtures")
            .appendingPathComponent(LegacyRealmFixture.fileName)

        try? FileManager.default.removeItem(at: url)

        autoreleasepool {
            let repositories = TestRepositories(backend: .realm, realmStore: .file(url: url))

            LegacyRealmFixture.populate(repositories)
            LegacyRealmFixture.verify(repositories)
        }
    }
}
