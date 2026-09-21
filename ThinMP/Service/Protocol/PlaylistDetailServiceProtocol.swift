//
//  PlaylistDetailServiceProtocol.swift
//  ThinMP
//
//  Created by tk on 2021/07/25.
//

@MainActor
protocol PlaylistDetailServiceProtocol {
    func findById(playlistId: PlaylistId) async -> PlaylistDetailModel

    func findByIds(playlistIds: [PlaylistId]) async -> [PlaylistDetailModel]
}
