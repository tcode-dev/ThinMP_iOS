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

    func findAll() -> [PlaylistModel] {
        let playlists = playlistRepository.findAll()

        return playlists.map { playlist in
            let playlistDetailModel = playlistDetailService.findById(playlistId: playlist.playlistId)

            return PlaylistModel(playlistId: playlist.playlistId, primaryText: playlistDetailModel.primaryText, artwork: playlistDetailModel.artwork)
        }
    }
}
