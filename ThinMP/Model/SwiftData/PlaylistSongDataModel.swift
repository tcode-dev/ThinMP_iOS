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
    // 同じプレイリストに同じ曲を 2 回入れられないようにストア側でも保証する
    // SwiftData の #Unique はリレーションを指定できないので playlistId を別カラムで持つ
    // 重複を insert すると既存行への upsert になりエラーは出ないので、Repository 側で先に弾いている
    #Unique<PlaylistSongDataModel>([\.playlistId, \.songId])

    var id: String
    var playlistId: String
    var songId: String
    var order: Int
    var playlist: PlaylistDataModel?

    init(id: String = UUID().uuidString, playlistId: String, songId: String, order: Int) {
        self.id = id
        self.playlistId = playlistId
        self.songId = songId
        self.order = order
    }
}
