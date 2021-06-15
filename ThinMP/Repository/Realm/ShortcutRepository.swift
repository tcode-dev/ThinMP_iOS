//
//  ShortcutRepository.swift
//  ThinMP
//
//  Created by tk on 2021/05/08.
//

import RealmSwift
import MediaPlayer

struct ShortcutRepository {
    var realm: Realm

    init() {
        realm = try! Realm()
    }

    func findAll() -> [ShortcutRealmModel] {
        return Array(realm.objects(ShortcutRealmModel.self).sorted(byKeyPath: "order", ascending: false))
    }

    func add(itemId: ShortcutItemIdProtocol, type: ShortcutType) {
        switch itemId {
        case let value as MPMediaEntityPersistentID: add(itemId: String(value), type: type)
        case let value as String: add(itemId: value, type: type)
        default: break
        }
    }

    func delete(itemId: ShortcutItemIdProtocol, type: ShortcutType) {
        switch itemId {
        case let value as MPMediaEntityPersistentID: delete(itemId: String(value), type: type)
        case let value as String: delete(itemId: value, type: type)
        default: break
        }
    }

    func exists(itemId: ShortcutItemIdProtocol, type: ShortcutType) -> Bool {
        switch itemId {
        case let value as MPMediaEntityPersistentID: return exists(itemId: String(value), type: type)
        case let value as String: return exists(itemId: value, type: type)
        default: return false
        }
    }

    func update(ids: [String]) {
        delete(ids: ids)
        sort(ids: ids)
    }

    private func sort(ids: [String]) {
        let models = findByIds(ids: ids)
        let sorted = ids.map { id in
            models.first{$0.id == id}
        }
        let count = sorted.count

        try! realm.write {
            for (index, model) in sorted.enumerated() {
                model?.order = count - index
            }
        }
    }

    private func add(itemId: String, type: ShortcutType) {
        if (exists(itemId: itemId, type: type)) {
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

    private func delete(itemId: String, type: ShortcutType) {
        let model = find(itemId: itemId, type: type)

        if (model.count == 0) {
            return
        }

        try! realm.write {
            realm.delete(model)
        }
    }

    private func delete(ids: [String]) {
        let currentIds: [String] = realm.objects(ShortcutRealmModel.self).map{$0.id}
        let deleteIds = currentIds.filter{ !ids.contains($0)}
        let models = findByIds(ids: deleteIds)

        if (models.count == 0) {
            return
        }

        try! realm.write {
            realm.delete(models)
        }
    }

    private func findByIds(ids: [String]) -> Results<ShortcutRealmModel> {
        return realm.objects(ShortcutRealmModel.self).filter("id IN %@", ids)
    }

    private func exists(itemId: String, type: ShortcutType) -> Bool {
        return find(itemId: itemId, type: type).count == 1
    }

    private func find(itemId: String, type: ShortcutType) -> Results<ShortcutRealmModel> {
        return realm.objects(ShortcutRealmModel.self).filter("itemId = '\(itemId)' AND type = \(type.rawValue)")
    }

    private func incrementOrder() -> Int {
        return (realm.objects(ShortcutRealmModel.self).max(ofProperty: "order") as Int? ?? 0) + 1
    }
}
