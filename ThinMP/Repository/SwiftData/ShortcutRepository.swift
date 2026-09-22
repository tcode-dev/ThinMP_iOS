//
//  ShortcutRepository.swift
//  ThinMP
//
//  Created by tk on 2026/09/21.
//

import Foundation
import SwiftData

struct ShortcutRepository: ShortcutRepositoryProtocol {
    private let store: SwiftDataStore

    init(store: SwiftDataStore = .default) {
        self.store = store
    }

    func add(itemId: ItemId, type: ShortcutType) {
        if exists(itemId: itemId, type: type) {
            return
        }

        store.context.insert(ShortcutDataModel(itemId: itemId.id, type: type, order: incrementOrder()))
        store.save()
    }

    func findAll() -> [ShortcutEntity] {
        let descriptor = FetchDescriptor<ShortcutDataModel>(sortBy: [SortDescriptor(\.order, order: .reverse)])

        return try! store.context.fetch(descriptor).compactMap { toEntity(model: $0) }
    }

    func exists(itemId: ItemId, type: ShortcutType) -> Bool {
        return !find(itemId: itemId, type: type).isEmpty
    }

    func update(shortcutIds: [ShortcutId]) {
        deleteExcept(shortcutIds: shortcutIds)
        sort(shortcutIds: shortcutIds)
    }

    func delete(itemId: ItemId, type: ShortcutType) {
        let models = find(itemId: itemId, type: type)

        if models.isEmpty {
            return
        }

        models.forEach { store.context.delete($0) }
        store.save()
    }

    private func find(itemId: ItemId, type: ShortcutType) -> [ShortcutDataModel] {
        let id = itemId.id
        let typeValue = type.rawValue
        let descriptor = FetchDescriptor<ShortcutDataModel>(predicate: #Predicate { $0.itemId == id && $0.type == typeValue })

        return try! store.context.fetch(descriptor)
    }

    private func findByIds(shortcutIds: [ShortcutId]) -> [ShortcutDataModel] {
        let ids = shortcutIds.map { $0.id }
        let descriptor = FetchDescriptor<ShortcutDataModel>(predicate: #Predicate { ids.contains($0.id) })

        return try! store.context.fetch(descriptor)
    }

    private func toEntity(model: ShortcutDataModel) -> ShortcutEntity? {
        return ShortcutEntity(id: model.id, itemId: model.itemId, type: model.type)
    }

    /// 渡した id 以外を消す。編集ページで消されたものを反映する
    private func deleteExcept(shortcutIds: [ShortcutId]) {
        let currentIds = try! store.context.fetch(FetchDescriptor<ShortcutDataModel>()).map { ShortcutId(id: $0.id) }
        let deleteIds = currentIds.filter { !shortcutIds.contains($0) }
        let models = findByIds(shortcutIds: deleteIds)

        if models.isEmpty {
            return
        }

        models.forEach { store.context.delete($0) }
        store.save()
    }

    private func incrementOrder() -> Int {
        var descriptor = FetchDescriptor<ShortcutDataModel>(sortBy: [SortDescriptor(\.order, order: .reverse)])

        descriptor.fetchLimit = 1

        return (try! store.context.fetch(descriptor).first?.order ?? 0) + 1
    }

    private func sort(shortcutIds: [ShortcutId]) {
        let models = findByIds(shortcutIds: shortcutIds)
        let count = shortcutIds.count

        for (index, shortcutId) in shortcutIds.enumerated() {
            models.first { $0.id == shortcutId.id }?.order = count - index
        }

        store.save()
    }
}
