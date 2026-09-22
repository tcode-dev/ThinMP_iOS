//
//  SwiftDataStore.swift
//  ThinMP
//
//  Created by tk on 2026/09/21.
//

import SwiftData

/// SwiftData の接続
/// アプリでは default を使い、テストではインメモリストアに差し替える
/// Repository は同じ store の context を共有するので、ある Repository の書き込みが別の Repository からすぐ見える
/// ModelContext はスレッドセーフではないので、この store とそれを使う Repository と、Repository を使う Service / ViewModel は
/// プロトコルごとメインアクターに隔離している。バックグラウンドから触るとコンパイルエラーになる
@MainActor
final class SwiftDataStore {
    static let `default` = SwiftDataStore(isStoredInMemoryOnly: false)

    static let schema = Schema([
        FavoriteSongDataModel.self,
        FavoriteArtistDataModel.self,
        PlaylistDataModel.self,
        PlaylistSongDataModel.self,
        ShortcutDataModel.self,
    ])

    let container: ModelContainer
    let context: ModelContext

    private init(isStoredInMemoryOnly: Bool) {
        let configuration = ModelConfiguration(schema: Self.schema, isStoredInMemoryOnly: isStoredInMemoryOnly)

        container = try! ModelContainer(for: Self.schema, configurations: [configuration])
        context = ModelContext(container)
        context.autosaveEnabled = false
    }

    static func inMemory() -> SwiftDataStore {
        return SwiftDataStore(isStoredInMemoryOnly: true)
    }

    func save() {
        try! context.save()
    }
}
