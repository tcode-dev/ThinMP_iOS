//
//  FavoriteSongRegisterProtocol.swift
//  ThinMP
//
//  Created by tk on 2021/07/25.
//

protocol FavoriteSongRegisterProtocol {
    func add(songId: SongId)

    func exists(songId: SongId) -> Bool

    func update(songIds: [SongId])

    func delete(songId: SongId)
}
