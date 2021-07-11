//
//  ShortcutId.swift
//  ThinMP
//
//  Created by tk on 2021/06/24.
//

struct ShortcutId: Equatable {
    var id: String

    static func == (left: ShortcutId, right: ShortcutId) -> Bool {
        return left.id == right.id
    }
}
