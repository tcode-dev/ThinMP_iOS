//
//  RepositoryBackend.swift
//  ThinMPTests
//
//  Created by tk on 2026/09/21.
//

@testable import ThinMP

/// Repository の実装を切り替えるための識別子
/// Repository のテストはこの全ケースに対して実行されるので、
/// 永続化ストアを追加するときはここに case を追加するだけで同じ契約テストが走る
enum RepositoryBackend: CaseIterable, Sendable {
    case realm
    case swiftData
}

/// テスト 1 件分の Repository 一式
/// 同じストアを共有しているので、Register 経由の書き込みが Repository から見える
struct TestRepositories {
    let favoriteSong: FavoriteSongRepositoryProtocol
    let favoriteArtist: FavoriteArtistRepositoryProtocol
    let playlist: PlaylistRepositoryProtocol
    let shortcut: ShortcutRepositoryProtocol

    init(backend: RepositoryBackend, realmStore: RealmStore? = nil, swiftDataStore: SwiftDataStore? = nil) {
        switch backend {
        case .realm:
            let store = realmStore ?? .inMemory()

            favoriteSong = FavoriteSongRealmRepository(store: store)
            favoriteArtist = FavoriteArtistRealmRepository(store: store)
            playlist = PlaylistRealmRepository(store: store)
            shortcut = ShortcutRealmRepository(store: store)
        case .swiftData:
            let store = swiftDataStore ?? .inMemory()

            favoriteSong = FavoriteSongRepository(store: store)
            favoriteArtist = FavoriteArtistRepository(store: store)
            playlist = PlaylistRepository(store: store)
            shortcut = ShortcutRepository(store: store)
        }
    }
}
