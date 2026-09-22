//
//  FavoriteSongsServiceTests.swift
//  ThinMPTests
//
//  Created by tk on 2026/09/21.
//

import Testing
@testable import ThinMP

@MainActor
struct FavoriteSongsServiceTests {
    @Test
    func returnsSongsInFavoriteOrder() async {
        let favoriteSongRepository = FavoriteSongRepositoryMock(songIds: [SongId(id: 3), SongId(id: 1)])
        let songRepository = SongRepositoryMock(songs: [.fake(id: 1), .fake(id: 2), .fake(id: 3)])
        let service = FavoriteSongsService(
            favoriteSongRepository: favoriteSongRepository,
            songRepository: songRepository
        )

        let songs = await service.findAll()

        #expect(songs.map { $0.songId.id } == [3, 1])
        #expect(favoriteSongRepository.updateCalls.isEmpty)
    }

    @Test
    func removesSongsMissingFromLibrary() async {
        let favoriteSongRepository = FavoriteSongRepositoryMock(songIds: [SongId(id: 1), SongId(id: 2), SongId(id: 3)])
        let songRepository = SongRepositoryMock(songs: [.fake(id: 1), .fake(id: 3)])
        let service = FavoriteSongsService(
            favoriteSongRepository: favoriteSongRepository,
            songRepository: songRepository
        )

        let songs = await service.findAll()

        #expect(songs.map { $0.songId.id } == [1, 3])
        #expect(favoriteSongRepository.updateCalls.count == 1)
        #expect(favoriteSongRepository.updateCalls[0].map { $0.id } == [1, 3])
        #expect(favoriteSongRepository.findAll().map { $0.id } == [1, 3])
    }

    /// トグルボタンと MusicPlayer が使う exists / add / delete は Repository にそのまま届く
    @Test
    func existsAddAndDeleteWriteThroughToRepository() {
        let favoriteSongRepository = FavoriteSongRepositoryMock()
        let service = FavoriteSongsService(favoriteSongRepository: favoriteSongRepository, songRepository: SongRepositoryMock(songs: []))

        #expect(!service.exists(songId: SongId(id: 1)))

        service.add(songId: SongId(id: 1))

        #expect(service.exists(songId: SongId(id: 1)))
        #expect(favoriteSongRepository.findAll() == [SongId(id: 1)])

        service.delete(songId: SongId(id: 1))

        #expect(!service.exists(songId: SongId(id: 1)))
        #expect(favoriteSongRepository.findAll().isEmpty)
    }

    /// 編集ページの保存は Repository の update にそのまま届く
    @Test
    func updateWritesThroughToRepository() {
        let favoriteSongRepository = FavoriteSongRepositoryMock(songIds: [SongId(id: 1), SongId(id: 2)])
        let service = FavoriteSongsService(favoriteSongRepository: favoriteSongRepository, songRepository: SongRepositoryMock(songs: []))

        service.update(songIds: [SongId(id: 2)])

        #expect(favoriteSongRepository.updateCalls == [[SongId(id: 2)]])
        #expect(favoriteSongRepository.findAll() == [SongId(id: 2)])
    }

    @Test
    func returnsEmptyWhenNoFavorites() async {
        let favoriteSongRepository = FavoriteSongRepositoryMock()
        let service = FavoriteSongsService(
            favoriteSongRepository: favoriteSongRepository,
            songRepository: SongRepositoryMock(songs: [.fake(id: 1)])
        )

        #expect(await service.findAll().isEmpty)
        #expect(favoriteSongRepository.updateCalls.isEmpty)
    }
}
