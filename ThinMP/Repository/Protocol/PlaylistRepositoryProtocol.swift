//
//  PlaylistRepositoryProtocol.swift
//  ThinMP
//
//  Created by tk on 2021/07/25.
//

protocol PlaylistRepositoryProtocol {
    func create(songId: SongId, name: String)

    func add(playlistId: PlaylistId, songId: SongId)

    func findAll() -> [PlaylistEntity]

    func findById(playlistId: PlaylistId) -> PlaylistEntity

    func findByIds(playlistIds: [PlaylistId]) -> [PlaylistEntity]

    func update(playlistIds: [PlaylistId])

    func update(playlistId: PlaylistId, name: String, songIds: [SongId])

    func delete(playlistId: PlaylistId)
}
