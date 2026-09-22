//
//  ShortcutRepositoryProtocol.swift
//  ThinMP
//
//  Created by tk on 2021/07/25.
//

@MainActor
protocol ShortcutRepositoryProtocol {
    func add(target: ShortcutTarget)

    func findAll() -> [ShortcutEntity]

    func exists(target: ShortcutTarget) -> Bool

    func update(shortcutIds: [ShortcutId])

    func delete(target: ShortcutTarget)
}
