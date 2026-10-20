//
//  RepositoryBackend.swift
//  ThinMPTests
//
//  Created by tk on 2026/09/21.
//

import SwiftData
@testable import ThinMP

/// Repository の実装を切り替えるための識別子
/// Repository のテストはこの全ケースに対して実行されるので、
/// 永続化ストアを追加するときはここに case を追加するだけで同じ契約テストが走る
enum RepositoryBackend: CaseIterable, Sendable {
    case swiftData
}

/// テスト 1 件分の Repository 一式
/// 同じストアを共有しているので、ある Repository の書き込みが別の Repository から見える
@MainActor
struct TestRepositories {
    let favoriteSong: FavoriteSongRepositoryProtocol
    let favoriteArtist: FavoriteArtistRepositoryProtocol
    let playlist: PlaylistRepositoryProtocol
    let shortcut: ShortcutRepositoryProtocol

    private let swiftDataStore: SwiftDataStore?

    init(backend: RepositoryBackend, swiftDataStore: SwiftDataStore? = nil) {
        switch backend {
        case .swiftData:
            let store = swiftDataStore ?? .inMemory()

            self.swiftDataStore = store
            favoriteSong = FavoriteSongRepository(store: store)
            favoriteArtist = FavoriteArtistRepository(store: store)
            playlist = PlaylistRepository(store: store)
            shortcut = ShortcutRepository(store: store)
        }
    }

    /// Repository を通さずにストアへ直接書く
    /// Repository 側で弾いている状態(同じ id の重複行など)を作って、その状態でも Repository が壊れないことを確かめるのに使う
    /// バックエンドに応じて該当するクロージャだけが呼ばれる
    func writeDirectly(swiftData writeSwiftData: (ModelContext) -> Void) {
        if let swiftDataStore {
            writeSwiftData(swiftDataStore.context)
            swiftDataStore.save()
        }
    }
}
