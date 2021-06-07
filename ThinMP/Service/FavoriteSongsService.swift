//
//  FavoriteSongsService.swift
//  ThinMP
//
//  Created by tk on 2021/06/07.
//

struct FavoriteSongsService {
    func findAll() -> [SongModel] {
        let favoriteSongRepository = FavoriteSongRepository()
        let persistentIds = favoriteSongRepository.findAll()
        let songRepository = SongRepository()

        return songRepository.findByIds(persistentIds: persistentIds)
    }
}
