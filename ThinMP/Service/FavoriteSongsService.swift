//
//  FavoriteSongsService.swift
//  ThinMP
//
//  Created by tk on 2021/06/07.
//

struct FavoriteSongsService: FavoriteSongsServiceProtocol {
    func findAll() -> [SongModel] {
        let favoriteSongRepository = FavoriteSongRepository()
        let songIds = favoriteSongRepository.findAll()
        let songRepository = SongRepository()
        let songs = songRepository.findByIds(songIds: songIds)

        if !validation(songIds: songIds, songs: songs) {
            fix(songs: songs)

            return findAll()
        }

        return songs
    }

    private func validation(songIds: [SongId], songs: [SongModel]) -> Bool {
        return songIds.count == songs.count
    }

    private func fix(songs: [SongModel]) {
        let register = FavoriteSongRegister()
        let songIds = songs.map { $0.songId }

        register.update(songIds: songIds)
    }
}
