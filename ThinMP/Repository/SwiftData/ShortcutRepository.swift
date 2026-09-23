//
//  ShortcutRepository.swift
//  ThinMP
//
//  Created by tk on 2026/09/21.
//

import Foundation
import SwiftData

/// ショートカットだけは新しいものを先頭に並べるので、order は他の Repository と逆に大きいものが先にくる
/// add は今ある最大 + 1 を振り、update は先頭から order を count, count - 1, ... と振り直す
struct ShortcutRepository: ShortcutRepositoryProtocol {
    private let store: SwiftDataStore

    init(store: SwiftDataStore = .default) {
        self.store = store
    }

    func add(target: ShortcutTarget) {
        if exists(target: target) {
            return
        }

        store.context.insert(ShortcutDataModel(itemId: target.itemId, type: target.type, order: store.nextOrder(ShortcutDataModel.self, by: \.order)))
        store.save()
    }

    /// 新しいものが先頭
    func findAll() -> [ShortcutEntity] {
        let descriptor = FetchDescriptor<ShortcutDataModel>(sortBy: [SortDescriptor(\.order, order: .reverse)])

        return try! store.context.fetch(descriptor).compactMap { toEntity(model: $0) }
    }

    /// 行そのものは要らないので、読み込まずに数だけ数える
    func exists(target: ShortcutTarget) -> Bool {
        return try! store.context.fetchCount(descriptor(target: target)) > 0
    }

    /// 渡したものだけを渡した順で残す。先頭ほど order が大きいので、新しく add したものが先頭にくる
    func update(shortcutIds: [ShortcutId]) {
        let count = shortcutIds.count
        let orderById = Dictionary(shortcutIds.enumerated().map { ($1.id, count - $0) }, uniquingKeysWith: { first, _ in first })

        for model in try! store.context.fetch(FetchDescriptor<ShortcutDataModel>()) {
            if let order = orderById[model.id] {
                model.order = order
            } else {
                store.context.delete(model)
            }
        }

        store.save()
    }

    func delete(target: ShortcutTarget) {
        let models = find(target: target)

        if models.isEmpty {
            return
        }

        models.forEach { store.context.delete($0) }
        store.save()
    }

    private func find(target: ShortcutTarget) -> [ShortcutDataModel] {
        return try! store.context.fetch(descriptor(target: target))
    }

    private func descriptor(target: ShortcutTarget) -> FetchDescriptor<ShortcutDataModel> {
        let id = target.itemId
        let typeValue = target.type.rawValue

        return FetchDescriptor<ShortcutDataModel>(predicate: #Predicate { $0.itemId == id && $0.type == typeValue })
    }

    /// 指す先が読めない行は nil
    private func toEntity(model: ShortcutDataModel) -> ShortcutEntity? {
        return ShortcutTarget(itemId: model.itemId, type: model.type).map { ShortcutEntity(shortcutId: ShortcutId(id: model.id), target: $0) }
    }
}
