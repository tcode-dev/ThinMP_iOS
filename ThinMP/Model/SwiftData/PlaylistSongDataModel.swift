//
//  PlaylistSongDataModel.swift
//  ThinMP
//
//  Created by tk on 2026/09/21.
//

import Foundation
import SwiftData

@Model
final class PlaylistSongDataModel {
    var id: String
    var songId: String
    var order: Int
    var playlist: PlaylistDataModel?

    init(id: String = UUID().uuidString, songId: String, order: Int) {
        self.id = id
        self.songId = songId
        self.order = order
    }
}
