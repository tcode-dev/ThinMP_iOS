//
//  ShortcutServiceProtocol.swift
//  ThinMP
//
//  Created by tk on 2021/07/25.
//

@MainActor
protocol ShortcutServiceProtocol {
    func findAll() async -> [ShortcutModel]

    func exists(itemId: ItemId, type: ShortcutType) -> Bool

    func add(itemId: ItemId, type: ShortcutType)

    func delete(itemId: ItemId, type: ShortcutType)

    /// 編集ページの並び順と削除を保存する
    func update(shortcutIds: [ShortcutId])
}
