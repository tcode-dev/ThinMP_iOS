//
//  FavoriteSongsServiceProtocol.swift
//  ThinMP
//
//  Created by tk on 2021/07/25.
//

@MainActor
protocol FavoriteSongsServiceProtocol {
    func findAll() async -> [SongModel]

    /// 編集ページの並び順と削除を保存する
    func update(songIds: [SongId])
}
