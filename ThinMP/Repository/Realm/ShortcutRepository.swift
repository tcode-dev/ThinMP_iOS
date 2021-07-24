//
//  ShortcutRepository.swift
//  ThinMP
//
//  Created by tk on 2021/05/08.
//

import MediaPlayer
import RealmSwift

struct ShortcutRepository: ShortcutRepositoryProtocol {
    let realm: Realm

    init() {
        realm = try! Realm()
    }

    func add(itemId: ShortcutItemIdProtocol, type: ShortcutType) {
        switch itemId {
        case let value as MPMediaEntityPersistentID: add(itemId: String(value), type: type)
        case let value as String: add(itemId: value, type: type)
        default: break
        }
    }

    func findAll() -> [ShortcutRealmModel] {
        return Array(realm.objects(ShortcutRealmModel.self).sorted(byKeyPath: ShortcutRealmModel.ORDER, ascending: false))
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

        let shortcut = ShortcutRealmModel()

        shortcut.itemId = itemId
        shortcut.type = type.rawValue
        shortcut.order = incrementOrder()

        try! realm.write {
            realm.add(shortcut)
        }
    }

    private func find(itemId: String, type: ShortcutType) -> Results<ShortcutRealmModel> {
        return realm.objects(ShortcutRealmModel.self).filter("\(ShortcutRealmModel.ITEM_ID) = '\(itemId)' AND \(ShortcutRealmModel.TYPE) = \(type.rawValue)")
    }

    private func findByIds(shortcutIds: [ShortcutId]) -> Results<ShortcutRealmModel> {
        return realm.objects(ShortcutRealmModel.self).filter("\(ShortcutRealmModel.ID) IN %@", shortcutIds.map { $0.id })
    }

    private func exists(itemId: String, type: ShortcutType) -> Bool {
        return find(itemId: itemId, type: type).count == 1
    }

    private func delete(itemId: String, type: ShortcutType) {
        let model = find(itemId: itemId, type: type)

        if model.count == 0 {
            return
        }

        try! realm.write {
            realm.delete(model)
        }
    }

    private func delete(shortcutIds: [ShortcutId]) {
        let currentIds = realm.objects(ShortcutRealmModel.self).map { ShortcutId(id: $0.id) }
        let deleteIds = Array(currentIds.filter { !shortcutIds.contains($0) })
        let models = findByIds(shortcutIds: deleteIds)

        if models.count == 0 {
            return
        }

        try! realm.write {
            realm.delete(models)
        }
    }

    private func incrementOrder() -> Int {
        return (realm.objects(ShortcutRealmModel.self).max(ofProperty: ShortcutRealmModel.ORDER) as Int? ?? 0) + 1
    }

    private func sort(shortcutIds: [ShortcutId]) {
        let models = findByIds(shortcutIds: shortcutIds)
        let sorted = shortcutIds.map { shortcutId in
            models.first { $0.id == shortcutId.id }
        }
        let count = sorted.count

        try! realm.write {
            for (index, model) in sorted.enumerated() {
                model?.order = count - index
            }
        }
    }
}
