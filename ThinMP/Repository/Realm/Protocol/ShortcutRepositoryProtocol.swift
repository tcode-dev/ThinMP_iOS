//
//  ShortcutRepositoryProtocol.swift
//  ThinMP
//
//  Created by tk on 2021/07/25.
//

protocol ShortcutRepositoryProtocol {
    func add(itemId: ShortcutItemIdProtocol, type: ShortcutType)

    func findAll() -> [ShortcutRealmModel]

    func exists(itemId: ShortcutItemIdProtocol, type: ShortcutType) -> Bool

    func update(shortcutIds: [ShortcutId])

    func delete(itemId: ShortcutItemIdProtocol, type: ShortcutType)
}
