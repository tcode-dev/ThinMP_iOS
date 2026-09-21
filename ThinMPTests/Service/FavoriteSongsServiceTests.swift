//
//  FavoriteSongsServiceTests.swift
//  ThinMPTests
//
//  Created by tk on 2026/09/21.
//

import Testing
@testable import ThinMP

struct FavoriteSongsServiceTests {
    @Test
    func returnsSongsInFavoriteOrder() {
        let favoriteSongRepository = FavoriteSongRepositoryMock(songIds: [SongId(id: 3), SongId(id: 1)])
        let songRepository = SongRepositoryMock(songs: [.fake(id: 1), .fake(id: 2), .fake(id: 3)])
        let service = FavoriteSongsService(
            favoriteSongRepository: favoriteSongRepository,
            songRepository: songRepository,
            favoriteSongRegister: FavoriteSongRegister(repository: favoriteSongRepository)
        )

        let songs = service.findAll()

        #expect(songs.map { $0.songId.id } == [3, 1])
        #expect(favoriteSongRepository.updateCalls.isEmpty)
    }

    @Test
    func removesSongsMissingFromLibrary() {
        let favoriteSongRepository = FavoriteSongRepositoryMock(songIds: [SongId(id: 1), SongId(id: 2), SongId(id: 3)])
        let songRepository = SongRepositoryMock(songs: [.fake(id: 1), .fake(id: 3)])
        let service = FavoriteSongsService(
            favoriteSongRepository: favoriteSongRepository,
            songRepository: songRepository,
            favoriteSongRegister: FavoriteSongRegister(repository: favoriteSongRepository)
        )

        let songs = service.findAll()

        #expect(songs.map { $0.songId.id } == [1, 3])
        #expect(favoriteSongRepository.updateCalls.count == 1)
        #expect(favoriteSongRepository.updateCalls[0].map { $0.id } == [1, 3])
        #expect(favoriteSongRepository.findAll().map { $0.id } == [1, 3])
    }

    @Test
    func returnsEmptyWhenNoFavorites() {
        let favoriteSongRepository = FavoriteSongRepositoryMock()
        let service = FavoriteSongsService(
            favoriteSongRepository: favoriteSongRepository,
            songRepository: SongRepositoryMock(songs: [.fake(id: 1)]),
            favoriteSongRegister: FavoriteSongRegister(repository: favoriteSongRepository)
        )

        #expect(service.findAll().isEmpty)
        #expect(favoriteSongRepository.updateCalls.isEmpty)
    }
}
