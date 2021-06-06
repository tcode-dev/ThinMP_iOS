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

    func findAll() -> [ShortcutModel] {
        return Array(realm.objects(ShortcutModel.self).sorted(byKeyPath: "order", ascending: false))
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

    private func add(itemId: String, type: ShortcutType) {
        if (exists(itemId: itemId, type: type)) {
            return
        }

        let shortcut = ShortcutModel()

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

    private func exists(itemId: String, type: ShortcutType) -> Bool {
        return find(itemId: itemId, type: type).count == 1
    }

    private func find(itemId: String, type: ShortcutType) -> Results<ShortcutModel> {
        return realm.objects(ShortcutModel.self).filter("itemId = '\(itemId)' AND type = \(type.rawValue)")
    }

    private func incrementOrder() -> Int {
        return (realm.objects(ShortcutModel.self).max(ofProperty: "order") as Int? ?? 0) + 1
    }
}
