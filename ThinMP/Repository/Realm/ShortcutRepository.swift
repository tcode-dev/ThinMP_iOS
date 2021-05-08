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
        return Array(realm.objects(ShortcutModel.self).sorted(byKeyPath: "order"))
    }

    func existsArtist(itemId: MPMediaEntityPersistentID) -> Bool {
        return exists(itemId: String(itemId), type: ShortcutType.ARTIST.rawValue)
    }

    func addArtist(itemId: MPMediaEntityPersistentID) {
        if (existsArtist(itemId: itemId)) {
            return
        }

        // MPMediaEntityPersistentID は UInt64のエイリアス
        // realmはUInt64を保存できないのでStringに変換して保存する
        add(itemId: String(itemId), type: ShortcutType.ARTIST)
    }

    func deleteArtist(itemId: MPMediaEntityPersistentID) {
        let model = find(itemId: String(itemId), type: ShortcutType.ARTIST.rawValue)

        if (model.count == 0) {
            return
        }

        try! realm.write {
            realm.delete(model)
        }
    }

    private func exists(itemId: String, type: Int) -> Bool {
        return find(itemId: itemId, type: type).count == 1
    }

    private func find(itemId: String, type: Int) -> Results<ShortcutModel> {
        return realm.objects(ShortcutModel.self).filter("itemId = '\(itemId)' AND type = \(type)")
    }

    private func add(itemId: String, type: ShortcutType) {
        let shortcut = ShortcutModel()

        shortcut.itemId = itemId
        shortcut.type = type.rawValue
        shortcut.order = incrementOrder()

        try! realm.write {
            realm.add(shortcut)
        }
    }

    private func incrementOrder() -> Int {
        return (realm.objects(ShortcutModel.self).max(ofProperty: "order") as Int? ?? 0) + 1
    }
}
