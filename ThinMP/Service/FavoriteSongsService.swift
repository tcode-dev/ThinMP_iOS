//
//  FavoriteSongsService.swift
//  ThinMP
//
//  Created by tk on 2021/06/07.
//

struct FavoriteSongsService {
    func findAll() -> [SongModel] {
        let favoriteSongRepository = FavoriteSongRepository()
        let songIds = favoriteSongRepository.findAll()
        let songRepository = SongRepository()

        return songRepository.findByIds(songIds: songIds)
    }
}
