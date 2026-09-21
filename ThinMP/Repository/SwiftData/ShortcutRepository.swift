//
//  ShortcutRepository.swift
//  ThinMP
//
//  Created by tk on 2026/09/21.
//

import Foundation
import MediaPlayer
import SwiftData

struct ShortcutRepository: ShortcutRepositoryProtocol {
    private let store: SwiftDataStore

    init(store: SwiftDataStore = .default) {
        self.store = store
    }

    func add(itemId: ShortcutItemIdProtocol, type: ShortcutType) {
        switch itemId {
        case let value as MPMediaEntityPersistentID: add(itemId: String(value), type: type)
        case let value as String: add(itemId: value, type: type)
        default: break
        }
    }

    func findAll() -> [ShortcutEntity] {
        let descriptor = FetchDescriptor<ShortcutDataModel>(sortBy: [SortDescriptor(\.order, order: .reverse)])

        return try! store.context.fetch(descriptor).compactMap { toEntity(model: $0) }
    }

    func exists(itemId: ShortcutItemIdProtocol, type: ShortcutType) -> Bool {
        switch itemId {
        case let value as MPMediaEntityPersistentID: return exists(itemId: String(value), type: type)
        case let value as String: return exists(itemId: value, type: type)
        default: return false
        }
    }

    func update(shortcutIds: [ShortcutId]) {
        delete(shortcutIds: shortcutIds)
        sort(shortcutIds: shortcutIds)
    }

    func delete(itemId: ShortcutItemIdProtocol, type: ShortcutType) {
        switch itemId {
        case let value as MPMediaEntityPersistentID: delete(itemId: String(value), type: type)
        case let value as String: delete(itemId: value, type: type)
        default: break
        }
    }

    private func add(itemId: String, type: ShortcutType) {
        if exists(itemId: itemId, type: type) {
            return
        }

        store.context.insert(ShortcutDataModel(itemId: itemId, type: type, order: incrementOrder()))
        store.save()
    }

    private func find(itemId: String, type: ShortcutType) -> [ShortcutDataModel] {
        let typeValue = type.rawValue
        let descriptor = FetchDescriptor<ShortcutDataModel>(predicate: #Predicate { $0.itemId == itemId && $0.type == typeValue })

        return try! store.context.fetch(descriptor)
    }

    private func findByIds(shortcutIds: [ShortcutId]) -> [ShortcutDataModel] {
        let ids = shortcutIds.map { $0.id }
        let descriptor = FetchDescriptor<ShortcutDataModel>(predicate: #Predicate { ids.contains($0.id) })

        return try! store.context.fetch(descriptor)
    }

    private func toEntity(model: ShortcutDataModel) -> ShortcutEntity? {
        guard let type = ShortcutType(rawValue: model.type) else {
            return nil
        }

        return ShortcutEntity(shortcutId: ShortcutId(id: model.id), itemId: ItemId(id: model.itemId), type: type)
    }

    private func exists(itemId: String, type: ShortcutType) -> Bool {
        return find(itemId: itemId, type: type).count == 1
    }

    private func delete(itemId: String, type: ShortcutType) {
        let models = find(itemId: itemId, type: type)

        if models.count == 0 {
            return
        }

        models.forEach { store.context.delete($0) }
        store.save()
    }

    private func delete(shortcutIds: [ShortcutId]) {
        let currentIds = try! store.context.fetch(FetchDescriptor<ShortcutDataModel>()).map { ShortcutId(id: $0.id) }
        let deleteIds = currentIds.filter { !shortcutIds.contains($0) }
        let models = findByIds(shortcutIds: deleteIds)

        if models.count == 0 {
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
