//
//  PlaylistEntity.swift
//  ThinMP
//
//  Created by tk on 2026/09/21.
//

/// Repository から返す永続化ストア非依存のプレイリスト
/// songIds は order 順に並んでいる
nonisolated struct PlaylistEntity {
    let playlistId: PlaylistId
    let name: String
    let songIds: [SongId]
}
