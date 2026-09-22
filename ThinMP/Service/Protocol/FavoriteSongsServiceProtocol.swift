//
//  FavoriteSongsServiceProtocol.swift
//  ThinMP
//
//  Created by tk on 2021/07/25.
//

@MainActor
protocol FavoriteSongsServiceProtocol {
    func findAll() async -> [SongModel]

    func exists(songId: SongId) -> Bool

    func add(songId: SongId)

    func delete(songId: SongId)

    /// 編集ページの並び順と削除を保存する
    func update(songIds: [SongId])
}
