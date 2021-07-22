//
//  PlaylistsService.swift
//  ThinMP
//
//  Created by tk on 2021/06/07.
//

import MediaPlayer

struct PlaylistsService {
    func findAll() -> [PlaylistModel] {
        let playlistRepository = PlaylistRepository()
        let playlists = playlistRepository.findAll()

        return playlists.map { playlist in
            let playlistId = PlaylistId(id: playlist.id)
            let playlistDetailService = PlaylistDetailService()
            let playlistDetailModel = playlistDetailService.findById(playlistId: playlistId)

            return PlaylistModel(playlistId: playlistId, primaryText: playlistDetailModel.primaryText, artwork: playlistDetailModel.artwork)
        }
    }
}
