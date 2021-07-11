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
        let songs = songRepository.findByIds(songIds: songIds)

        if !validation(songIds: songIds, songs: songs) {
            return findAll()
        }

        return songs
    }

    private func validation(songIds: [SongId], songs: [SongModel]) -> Bool {
        if songIds.count == songs.count {
            return true
        }

        update(songs: songs)

        return false
    }

    private func update(songs: [SongModel]) {
        let register = FavoriteSongRegister()
        let songIds = songs.map { $0.songId }

        register.update(songIds: songIds)
    }
}
