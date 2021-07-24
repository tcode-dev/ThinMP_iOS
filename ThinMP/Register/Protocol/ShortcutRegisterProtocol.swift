//
//  ShortcutRegisterProtocol.swift
//  ThinMP
//
//  Created by tk on 2021/07/25.
//

protocol ShortcutRegisterProtocol {
    func add(itemId: ShortcutItemIdProtocol, type: ShortcutType)

    func exists(itemId: ShortcutItemIdProtocol, type: ShortcutType) -> Bool

    func update(shortcutIds: [ShortcutId])

    func delete(itemId: ShortcutItemIdProtocol, type: ShortcutType)
}
