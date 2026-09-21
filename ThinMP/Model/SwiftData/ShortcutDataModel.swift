//
//  ShortcutDataModel.swift
//  ThinMP
//
//  Created by tk on 2026/09/21.
//

import Foundation
import SwiftData

@Model
final class ShortcutDataModel {
    var id: String
    var itemId: String
    var type: Int
    var order: Int

    init(id: String = UUID().uuidString, itemId: String, type: ShortcutType, order: Int) {
        self.id = id
        self.itemId = itemId
        self.type = type.rawValue
        self.order = order
    }
}
