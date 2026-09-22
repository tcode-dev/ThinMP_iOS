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

    func add(target: ShortcutTarget) {
        if exists(target: target) {
            return
        }

        let shortcut = ShortcutRealmModel()

        shortcut.itemId = target.itemId
        shortcut.type = target.type.rawValue
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

    func exists(target: ShortcutTarget) -> Bool {
        return !find(target: target).isEmpty
    }

    func update(shortcutIds: [ShortcutId]) {
        deleteExcept(shortcutIds: shortcutIds)
        sort(shortcutIds: shortcutIds)
    }

    func delete(target: ShortcutTarget) {
        let model = find(target: target)

        if model.isEmpty {
            return
        }

        try! realm.write {
            realm.delete(model)
        }
    }

    private func find(target: ShortcutTarget) -> Results<ShortcutRealmModel> {
        return realm.objects(ShortcutRealmModel.self).filter("\(ShortcutRealmModel.ITEM_ID) = '\(target.itemId)' AND \(ShortcutRealmModel.TYPE) = \(target.type.rawValue)")
    }

    private func findByIds(shortcutIds: [ShortcutId]) -> Results<ShortcutRealmModel> {
        return realm.objects(ShortcutRealmModel.self).filter("\(ShortcutRealmModel.ID) IN %@", shortcutIds.map { $0.id })
    }

    /// 指す先が読めない行は nil
    private func toEntity(model: ShortcutRealmModel) -> ShortcutEntity? {
        return ShortcutTarget(itemId: model.itemId, type: model.type).map { ShortcutEntity(shortcutId: ShortcutId(id: model.id), target: $0) }
    }

    /// 渡した id 以外を消す。編集ページで消されたものを反映する
    private func deleteExcept(shortcutIds: [ShortcutId]) {
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
