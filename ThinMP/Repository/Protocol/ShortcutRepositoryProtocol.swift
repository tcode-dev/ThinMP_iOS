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

extension ShortcutRepositoryProtocol {
    /// 登録済みなら外し、未登録なら入れる。切り替えたあとの登録状態を返す
    @discardableResult
    func toggle(target: ShortcutTarget) -> Bool {
        if exists(target: target) {
            delete(target: target)

            return false
        }

        add(target: target)

        return true
    }
}
