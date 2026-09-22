//
//  PlaylistDataModel.swift
//  ThinMP
//
//  Created by tk on 2026/09/21.
//

import Foundation
import SwiftData

@Model
final class PlaylistDataModel {
    var id: String
    var name: String
    var order: Int

    /// SwiftData のリレーションは順序を保持しないので PlaylistSongDataModel.order で並べる
    @Relationship(deleteRule: .cascade, inverse: \PlaylistSongDataModel.playlist)
    var songs: [PlaylistSongDataModel]

    init(id: String = UUID().uuidString, name: String, order: Int, songs: [PlaylistSongDataModel] = []) {
        self.id = id
        self.name = name
        self.order = order
        self.songs = songs
    }

    var sortedSongs: [PlaylistSongDataModel] {
        return songs.sorted { $0.order < $1.order }
    }
}
