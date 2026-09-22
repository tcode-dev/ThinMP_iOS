//
//  PlaylistsServiceProtocol.swift
//  ThinMP
//
//  Created by tk on 2021/07/25.
//

@MainActor
protocol PlaylistsServiceProtocol {
    func findAll() async -> [PlaylistModel]

    /// 曲 1 つを入れた新しいプレイリストを作る
    func create(songId: SongId, name: String)

    func add(playlistId: PlaylistId, songId: SongId)

    /// 編集ページの並び順と削除を保存する
    func update(playlistIds: [PlaylistId])

    func delete(playlistId: PlaylistId)
}
