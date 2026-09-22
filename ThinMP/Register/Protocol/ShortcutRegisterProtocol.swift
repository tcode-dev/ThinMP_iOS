//
//  ShortcutRegisterProtocol.swift
//  ThinMP
//
//  Created by tk on 2021/07/25.
//

@MainActor
protocol ShortcutRegisterProtocol {
    func add(itemId: ItemId, type: ShortcutType)

    func exists(itemId: ItemId, type: ShortcutType) -> Bool

    func update(shortcutIds: [ShortcutId])

    func delete(itemId: ItemId, type: ShortcutType)
}
