//
//  ShortcutRealmRepository.swift
//  ThinMP
//
//  Created by tk on 2021/05/08.
//

import RealmSwift

struct ShortcutRealmRepository: ShortcutRepositoryProtocol {
    private let realm: Realm

    init(store: RealmStore = .default) {
        realm = store.realm()
    }

    func add(itemId: ItemId, type: ShortcutType) {
        if exists(itemId: itemId, type: type) {
            return
        }

        let shortcut = ShortcutRealmModel()

        shortcut.itemId = itemId.id
        shortcut.type = type.rawValue
        shortcut.order = incrementOrder()

        try! realm.write {
            realm.add(shortcut)
        }
    }

    func findAll() -> [ShortcutEntity] {
        return realm.objects(ShortcutRealmModel.self)
            .sorted(byKeyPath: ShortcutRealmModel.ORDER, ascending: false)
            .compactMap { toEntity(model: $0) }
    }

    func exists(itemId: ItemId, type: ShortcutType) -> Bool {
        return !find(itemId: itemId, type: type).isEmpty
    }

    func update(shortcutIds: [ShortcutId]) {
        delete(shortcutIds: shortcutIds)
        sort(shortcutIds: shortcutIds)
    }

    func delete(itemId: ItemId, type: ShortcutType) {
        let model = find(itemId: itemId, type: type)

        if model.isEmpty {
            return
        }

        try! realm.write {
            realm.delete(model)
        }
    }

    private func find(itemId: ItemId, type: ShortcutType) -> Results<ShortcutRealmModel> {
        return realm.objects(ShortcutRealmModel.self).filter("\(ShortcutRealmModel.ITEM_ID) = '\(itemId.id)' AND \(ShortcutRealmModel.TYPE) = \(type.rawValue)")
    }

    private func findByIds(shortcutIds: [ShortcutId]) -> Results<ShortcutRealmModel> {
        return realm.objects(ShortcutRealmModel.self).filter("\(ShortcutRealmModel.ID) IN %@", shortcutIds.map { $0.id })
    }

    private func toEntity(model: ShortcutRealmModel) -> ShortcutEntity? {
        return ShortcutEntity(id: model.id, itemId: model.itemId, type: model.type)
    }

    private func delete(shortcutIds: [ShortcutId]) {
        let currentIds = realm.objects(ShortcutRealmModel.self).map { ShortcutId(id: $0.id) }
        let deleteIds = Array(currentIds.filter { !shortcutIds.contains($0) })
        let models = findByIds(shortcutIds: deleteIds)

        if models.isEmpty {
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
