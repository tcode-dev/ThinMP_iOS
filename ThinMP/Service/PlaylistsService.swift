//
//  PlaylistsService.swift
//  ThinMP
//
//  Created by tk on 2021/06/07.
//

struct PlaylistsService {
    func findAll() -> [PlaylistModel] {
        let playlistRepository = PlaylistRepository()

        return playlistRepository.findAll()
    }
}
