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
        #expect(favoriteSongRepository.deleteCalls.isEmpty)
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
        #expect(favoriteSongRepository.deleteCalls.map { $0.id } == [2])
        #expect(favoriteSongRepository.updateCalls.isEmpty)
        #expect(favoriteSongRepository.findAll().map { $0.id } == [1, 3])
    }

    /// 端末から外されただけでクラウドにある曲は、一覧には出さないがお気に入りには残す
    @Test
    func keepsCloudOnlySongs() async {
        let favoriteSongRepository = FavoriteSongRepositoryMock(songIds: [SongId(id: 1), SongId(id: 2), SongId(id: 3)])
        let songRepository = SongRepositoryMock(songs: [.fake(id: 1)], cloudSongIds: [SongId(id: 2)])
        let service = FavoriteSongsService(
            favoriteSongRepository: favoriteSongRepository,
            songRepository: songRepository
        )

        let songs = await service.findAll()

        #expect(songs.map { $0.songId.id } == [1])
        #expect(favoriteSongRepository.deleteCalls.map { $0.id } == [3])
        #expect(favoriteSongRepository.findAll().map { $0.id } == [1, 2])
    }

    /// クラウドも含めた確認には端末で見つからなかった曲だけを渡す(全部見つかれば空なので、全件走査は走らない)
    @Test
    func checksOnlySongsMissingFromDevice() async {
        let songRepository = SongRepositoryMock(songs: [.fake(id: 1), .fake(id: 3)])
        let service = FavoriteSongsService(
            favoriteSongRepository: FavoriteSongRepositoryMock(songIds: [SongId(id: 1), SongId(id: 2), SongId(id: 3)]),
            songRepository: songRepository
        )

        _ = await service.findAll()

        #expect(songRepository.findDeletedIdsCalls == [[SongId(id: 2)]])
    }

    /// 走査中に(再生画面などで)登録された曲は、端末から消えた曲を取り除いても残る
    @Test
    func keepsSongAddedDuringScan() async {
        let favoriteSongRepository = FavoriteSongRepositoryMock(songIds: [SongId(id: 1), SongId(id: 2)])
        let songRepository = SongRepositoryMock(songs: [.fake(id: 1), .fake(id: 3)])
        songRepository.onFindByIds = {
            runOnMainActor { favoriteSongRepository.add(songId: SongId(id: 3)) }
        }
        let service = FavoriteSongsService(
            favoriteSongRepository: favoriteSongRepository,
            songRepository: songRepository
        )

        _ = await service.findAll()

        #expect(favoriteSongRepository.findAll().map { $0.id } == [1, 3])
    }

    @Test
    func returnsEmptyWhenNoFavorites() async {
        let favoriteSongRepository = FavoriteSongRepositoryMock()
        let service = FavoriteSongsService(
            favoriteSongRepository: favoriteSongRepository,
            songRepository: SongRepositoryMock(songs: [.fake(id: 1)])
        )

        #expect(await service.findAll().isEmpty)
        #expect(favoriteSongRepository.deleteCalls.isEmpty)
    }
}
