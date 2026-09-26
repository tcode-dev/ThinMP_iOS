//
//  RealmToSwiftDataMigration.swift
//  ThinMP
//
//  Created by tk on 2026/09/21.
//

import Foundation
import RealmSwift

/// 2026 年のリリースで Realm から SwiftData に移行するための処理
/// 移行が終わったら Realm ファイルを削除する
/// 2027 年のリリースでこのファイル、Repository/Realm、Model/Realm、Realm パッケージをまとめて削除する
struct RealmToSwiftDataMigration {
    static let migratedKey = "realmToSwiftDataMigrated"

    private let realmStore: RealmStore
    private let swiftDataStore: SwiftDataStore
    private let userDefaults: UserDefaults

    init(realmStore: RealmStore = .default, swiftDataStore: SwiftDataStore = .default, userDefaults: UserDefaults = .standard) {
        self.realmStore = realmStore
        self.swiftDataStore = swiftDataStore
        self.userDefaults = userDefaults
    }

    /// アプリ起動時に呼ぶ
    /// 移行済みなら何もしない。Realm ファイルが無ければ新規インストールとみなして移行済みにする
    func migrateIfNeeded() {
        if userDefaults.bool(forKey: Self.migratedKey) {
            return
        }

        guard let fileURL = realmStore.configuration.fileURL, FileManager.default.fileExists(atPath: fileURL.path) else {
            userDefaults.set(true, forKey: Self.migratedKey)

            return
        }

        // 前回の起動で移行後にファイル削除まで到達しなかった場合は、二重に入れないようにコピーを飛ばす
        if isSwiftDataEmpty() {
            migrate()
        }

        userDefaults.set(true, forKey: Self.migratedKey)
        deleteRealmFiles()
    }

    /// Realm の内容を SwiftData にコピーする
    /// PlaylistId はショートカットから参照されているのでそのまま引き継ぐ
    func migrate() {
        // Realm インスタンスはファイル削除の前に解放しておく必要があるので autoreleasepool で囲む
        autoreleasepool {
            let favoriteSongs = FavoriteSongRealmRepository(store: realmStore).findAll()
            let favoriteArtists = FavoriteArtistRealmRepository(store: realmStore).findAll()
            let playlists = PlaylistRealmRepository(store: realmStore).findAll()
            let shortcuts = ShortcutRealmRepository(store: realmStore).findAll()
            let context = swiftDataStore.context

            for (index, songId) in favoriteSongs.enumerated() {
                context.insert(FavoriteSongDataModel(songId: String(songId.id), order: index))
            }

            for (index, artistId) in favoriteArtists.enumerated() {
                context.insert(FavoriteArtistDataModel(artistId: String(artistId.id), order: index))
            }

            for (index, playlist) in playlists.enumerated() {
                let model = PlaylistDataModel(id: playlist.playlistId.id, name: playlist.name, order: index)

                context.insert(model)

                // Realm 時代は同じ曲を重複して登録できたので、最初の 1 回だけ残して移行する
                for (songIndex, songId) in playlist.songIds.uniqued().enumerated() {
                    let song = PlaylistSongDataModel(playlistId: model.id, songId: String(songId.id), order: songIndex)

                    context.insert(song)
                    model.songs.append(song)
                }
            }

            // ShortcutRepository.findAll は新しい順なので、order は先頭が最大になるように振る
            let count = shortcuts.count

            for (index, shortcut) in shortcuts.enumerated() {
                context.insert(ShortcutDataModel(id: shortcut.shortcutId.id, itemId: shortcut.target.itemId, type: shortcut.target.type, order: count - index))
            }

            swiftDataStore.save()
        }
    }

    private func isSwiftDataEmpty() -> Bool {
        return FavoriteSongRepository(store: swiftDataStore).findAll().isEmpty
            && FavoriteArtistRepository(store: swiftDataStore).findAll().isEmpty
            && PlaylistRepository(store: swiftDataStore).findAll().isEmpty
            && ShortcutRepository(store: swiftDataStore).findAll().isEmpty
    }

    private func deleteRealmFiles() {
        _ = try? Realm.deleteFiles(for: realmStore.configuration)
    }
}
