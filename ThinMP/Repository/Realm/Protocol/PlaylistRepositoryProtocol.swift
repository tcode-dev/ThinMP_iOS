//
//  PlaylistRepositoryProtocol.swift
//  ThinMP
//
//  Created by tk on 2021/07/25.
//

import Foundation

protocol PlaylistRepositoryProtocol {
    func create(songId: SongId, name: String)

    func add(playlistId: PlaylistId, songId: SongId)

    func findAll() -> [PlaylistRealmModel]

    func findById(playlistId: PlaylistId) -> PlaylistRealmModel

    func findByIds(playlistIds: [PlaylistId]) -> [PlaylistRealmModel]

    // プレイリスト一覧の更新
    func update(playlistIds: [PlaylistId])

    // プレイリスト詳細の更新
    func update(playlistId: PlaylistId, name: String, songIds: [SongId])

    func delete(playlistId: PlaylistId)
}
