//
//  PlaylistDetailServiceProtocol.swift
//  ThinMP
//
//  Created by tk on 2021/07/25.
//

@MainActor
protocol PlaylistDetailServiceProtocol {
    func findById(playlistId: PlaylistId) async -> PlaylistDetailModel?

    func findByIds(playlistIds: [PlaylistId]) async -> [PlaylistDetailModel]

    /// 編集ページの名前、並び順、削除を保存する
    func update(playlistId: PlaylistId, name: String, songIds: [SongId])
}
