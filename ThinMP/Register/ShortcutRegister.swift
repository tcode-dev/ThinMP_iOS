//
//  ShortcutRegister.swift
//  ThinMP
//
//  Created by tk on 2021/05/08.
//

import MediaPlayer

struct ShortcutRegister {
    var repository: ShortcutRepository

    init() {
        repository = ShortcutRepository()
    }

    func exists(itemId: ShortcutItemIdProtocol, type: ShortcutType) -> Bool {
        return repository.exists(itemId: itemId, type: type)
    }

    func add(itemId: ShortcutItemIdProtocol, type: ShortcutType) {
        repository.add(itemId: itemId, type: type)
    }

    func delete(itemId: ShortcutItemIdProtocol, type: ShortcutType) {
        repository.delete(itemId: itemId, type: type)
    }

    func update(shortcutIds: [ShortcutId]) {
        repository.update(shortcutIds: shortcutIds)
    }
}
