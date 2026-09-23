//
//  FavoriteRepository.swift
//  ThinMP
//
//  Created by tk on 2026/09/23.
//

import Foundation
import SwiftData

/// お気に入り(アーティスト、曲)の読み書き
/// 扱うのは mediaId(MPMediaEntityPersistentID を文字列にしたもの)だけで、
/// ArtistId / SongId との変換はこれを持つ FavoriteArtistRepository / FavoriteSongRepository が行う
@MainActor
struct FavoriteRepository<Model: FavoriteDataModel> {
    private let store: SwiftDataStore

    init(store: SwiftDataStore) {
        self.store = store
    }

    /// 登録した順。ストアに同じ mediaId の行が残っていても最初の 1 回だけ返す(一覧の id が重複しないように)
    func findAll() -> [String] {
        let descriptor = FetchDescriptor<Model>(sortBy: [SortDescriptor(Model.orderKey)])

        return try! store.context.fetch(descriptor).map { $0.mediaId }.uniqued()
    }

    func exists(mediaId: String) -> Bool {
        return !find(mediaId: mediaId).isEmpty
    }

    func add(mediaId: String) {
        if exists(mediaId: mediaId) {
            return
        }

        store.context.insert(Model(mediaId: mediaId, order: store.nextOrder(Model.self, by: Model.orderKey)))
        store.save()
    }

    /// 渡したものだけを渡した順で残す。編集ページの並び替えと削除を反映する
    /// お気に入りの行は mediaId と order しか持たず、行の id はどこからも参照されないので、全部消して入れ直す
    /// プレイリストは曲をリレーションで持ち、id がショートカットから参照されるので、この方法は取れない
    func update(mediaIds: [String]) {
        truncate()

        // 同じ mediaId は最初の 1 回だけ残す(PlaylistRepository.update と同じ)
        for (index, mediaId) in mediaIds.uniqued().enumerated() {
            store.context.insert(Model(mediaId: mediaId, order: index))
        }

        store.save()
    }

    func delete(mediaId: String) {
        let models = find(mediaId: mediaId)

        if models.isEmpty {
            return
        }

        models.forEach { store.context.delete($0) }
        store.save()
    }

    private func find(mediaId: String) -> [Model] {
        let descriptor = FetchDescriptor<Model>(predicate: Model.predicate(mediaId: mediaId))

        return try! store.context.fetch(descriptor)
    }

    private func truncate() {
        let models = try! store.context.fetch(FetchDescriptor<Model>())

        models.forEach { store.context.delete($0) }
    }
}
