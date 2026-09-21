//
//  PlaylistsService.swift
//  ThinMP
//
//  Created by tk on 2021/06/07.
//

import MediaPlayer

struct PlaylistsService: PlaylistsServiceProtocol {
    private let playlistRepository: PlaylistRepositoryProtocol
    private let playlistDetailService: PlaylistDetailServiceProtocol

    init(
        playlistRepository: PlaylistRepositoryProtocol = PlaylistRepository(),
        playlistDetailService: PlaylistDetailServiceProtocol = PlaylistDetailService()
    ) {
        self.playlistRepository = playlistRepository
        self.playlistDetailService = playlistDetailService
    }

    func findAll() async -> [PlaylistModel] {
        let playlistIds = playlistRepository.findAll().map { $0.playlistId }

        // プレイリストごとに findById を呼ぶとライブラリ全件取得がその回数だけ走るので、まとめて 1 回で解決する
        return await playlistDetailService.findByIds(playlistIds: playlistIds).map { playlist in
            PlaylistModel(playlistId: playlist.playlistId, primaryText: playlist.primaryText, artwork: playlist.artwork, songIds: playlist.songs.map { $0.songId })
        }
    }
}
