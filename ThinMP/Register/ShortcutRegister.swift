//
//  ShortcutRegister.swift
//  ThinMP
//
//  Created by tk on 2021/05/08.
//

struct ShortcutRegister: ShortcutRegisterProtocol {
    private let repository: ShortcutRepositoryProtocol

    init(repository: ShortcutRepositoryProtocol = ShortcutRepository()) {
        self.repository = repository
    }

    func add(itemId: ItemId, type: ShortcutType) {
        repository.add(itemId: itemId, type: type)
    }

    func exists(itemId: ItemId, type: ShortcutType) -> Bool {
        return repository.exists(itemId: itemId, type: type)
    }

    func update(shortcutIds: [ShortcutId]) {
        repository.update(shortcutIds: shortcutIds)
    }

    func delete(itemId: ItemId, type: ShortcutType) {
        repository.delete(itemId: itemId, type: type)
    }
}
