//
//  PlaylistDetailServiceProtocol.swift
//  ThinMP
//
//  Created by tk on 2021/07/25.
//

protocol PlaylistDetailServiceProtocol {
    func findById(playlistId: PlaylistId) async -> PlaylistDetailModel?

    func findByIds(playlistIds: [PlaylistId]) async -> [PlaylistDetailModel]

    /// 全プレイリスト。並びは PlaylistRepository.findAll と同じ
    func findAll() async -> [PlaylistDetailModel]
}
