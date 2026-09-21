//
//  FavoriteSongDataModel.swift
//  ThinMP
//
//  Created by tk on 2026/09/21.
//

import Foundation
import SwiftData

@Model
final class FavoriteSongDataModel {
    var id: String
    // MPMediaEntityPersistentID は UInt64 のエイリアス
    // Int64 の範囲を超える値があるので String に変換して保存する
    var songId: String
    var order: Int

    init(id: String = UUID().uuidString, songId: String, order: Int) {
        self.id = id
        self.songId = songId
        self.order = order
    }
}
