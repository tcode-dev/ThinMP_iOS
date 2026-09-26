//
//  SwiftDataStore.swift
//  ThinMP
//
//  Created by tk on 2026/09/21.
//

import Foundation
import SwiftData

/// SwiftData の接続
/// アプリでは default を使い、テストではインメモリストアに差し替える
/// Repository は同じ store の context を共有するので、ある Repository の書き込みが別の Repository からすぐ見える
/// ModelContext はスレッドセーフではないので、この store とそれを使う Repository と、Repository を使う Service / ViewModel は
/// アプリのデフォルトの隔離のままメインアクターに置く。バックグラウンドから触るとコンパイルエラーになる
/// ライブラリの走査でバックグラウンドに出る Media の Model / Repository / Service だけを nonisolated にしている
final class SwiftDataStore {
    static let `default` = SwiftDataStore(isStoredInMemoryOnly: false)
    /// save() のたびに投げる。object は保存した store
    /// 登録 / 解除のボタンが、再生画面など別の場所での書き込みを表示に反映するのに使う
    static let didSave = Notification.Name("SwiftDataStoreDidSave")

    private static let schema = Schema([
        FavoriteSongDataModel.self,
        FavoriteArtistDataModel.self,
        PlaylistDataModel.self,
        PlaylistSongDataModel.self,
        ShortcutDataModel.self,
    ])

    /// context が保持しているが、この store がストアへの接続を持っていることを表すために置いている
    private let container: ModelContainer
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
        NotificationCenter.default.post(name: Self.didSave, object: self)
    }

    /// 末尾に足すための order。今ある最大 + 1 で、行が無ければ 0(update が振り直す番号と同じく 0 から始める)
    func nextOrder<Model: PersistentModel>(_: Model.Type, by order: KeyPath<Model, Int> & Sendable) -> Int {
        var descriptor = FetchDescriptor<Model>(sortBy: [SortDescriptor(order, order: .reverse)])

        descriptor.fetchLimit = 1

        return (try! context.fetch(descriptor).first?[keyPath: order] ?? -1) + 1
    }
}
