//
//  PlaylistEntity.swift
//  ThinMP
//
//  Created by tk on 2026/09/21.
//

/// Repository から返す永続化ストア非依存のプレイリスト
/// songIds は order 順に並んでいる
struct PlaylistEntity {
    var playlistId: PlaylistId
    var name: String
    var songIds: [SongId]
}
