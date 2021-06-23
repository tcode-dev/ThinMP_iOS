//
//  ShortcutId.swift
//  ThinMP
//
//  Created by tk on 2021/06/24.
//

struct ShortcutId: Equatable {
    var id: String

    static func == (l: ShortcutId, r: ShortcutId) -> Bool {
        return l.id == r.id
    }
}
