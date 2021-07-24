//
//  PlaylistRepositoryProtocol.swift
//  ThinMP
//
//  Created by tk on 2021/07/25.
//

protocol PlaylistRepositoryProtocol {
    func create(songId: SongId, name: String)

    func add(playlistId: PlaylistId, songId: SongId)

    func findAll() -> [PlaylistRealmModel]

    func findById(playlistId: PlaylistId) -> PlaylistRealmModel

    func findByIds(playlistIds: [PlaylistId]) -> [PlaylistRealmModel]

    func update(playlistIds: [PlaylistId])

    func update(playlistId: PlaylistId, name: String, songIds: [SongId])

    func delete(playlistId: PlaylistId)
}
