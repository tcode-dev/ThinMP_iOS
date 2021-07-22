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
            let playlistDetailService = PlaylistDetailService()
            let playlistDetailModel = playlistDetailService.findById(playlistId: PlaylistId(id: playlist.id))

            return PlaylistModel(playlistId: PlaylistId(id: playlist.id), primaryText: playlist.name, artwork: playlistDetailModel.artwork)
        }
    }
}
