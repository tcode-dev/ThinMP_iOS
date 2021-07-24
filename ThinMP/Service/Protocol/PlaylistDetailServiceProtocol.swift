//
//  PlaylistDetailServiceProtocol.swift
//  ThinMP
//
//  Created by tk on 2021/07/25.
//

protocol PlaylistDetailServiceProtocol {
    func findById(playlistId: PlaylistId) -> PlaylistDetailModel

    func findByIds(playlistIds: [PlaylistId]) -> [PlaylistDetailModel]
}
