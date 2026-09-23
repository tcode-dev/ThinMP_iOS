//
//  FavoriteArtistsServiceTests.swift
//  ThinMPTests
//
//  Created by tk on 2026/09/21.
//

import Testing
@testable import ThinMP

@MainActor
struct FavoriteArtistsServiceTests {
    @Test
    func returnsArtistsInFavoriteOrder() async {
        let favoriteArtistRepository = FavoriteArtistRepositoryMock(artistIds: [ArtistId(id: 3), ArtistId(id: 1)])
        let artistRepository = ArtistRepositoryMock(artists: [
            ArtistModel(artistId: ArtistId(id: 1), primaryText: "A"),
            ArtistModel(artistId: ArtistId(id: 2), primaryText: "B"),
            ArtistModel(artistId: ArtistId(id: 3), primaryText: "C"),
        ])
        let service = FavoriteArtistsService(
            favoriteArtistRepository: favoriteArtistRepository,
            artistRepository: artistRepository
        )

        let artists = await service.findAll()

        #expect(artists.map { $0.primaryText } == ["C", "A"])
        #expect(favoriteArtistRepository.deleteCalls.isEmpty)
    }

    @Test
    func removesArtistsMissingFromLibrary() async {
        let favoriteArtistRepository = FavoriteArtistRepositoryMock(artistIds: [ArtistId(id: 1), ArtistId(id: 2), ArtistId(id: 3)])
        let artistRepository = ArtistRepositoryMock(artists: [
            ArtistModel(artistId: ArtistId(id: 1), primaryText: "A"),
            ArtistModel(artistId: ArtistId(id: 3), primaryText: "C"),
        ])
        let service = FavoriteArtistsService(
            favoriteArtistRepository: favoriteArtistRepository,
            artistRepository: artistRepository
        )

        let artists = await service.findAll()

        #expect(artists.map { $0.artistId.id } == [1, 3])
        #expect(favoriteArtistRepository.deleteCalls.map { $0.id } == [2])
        #expect(favoriteArtistRepository.updateCalls.isEmpty)
        #expect(favoriteArtistRepository.findAll().map { $0.id } == [1, 3])
    }

    /// 走査中に(再生画面などで)登録されたアーティストは、端末から消えたアーティストを取り除いても残る
    @Test
    func keepsArtistAddedDuringScan() async {
        let favoriteArtistRepository = FavoriteArtistRepositoryMock(artistIds: [ArtistId(id: 1), ArtistId(id: 2)])
        let artistRepository = ArtistRepositoryMock(artists: [
            ArtistModel(artistId: ArtistId(id: 1), primaryText: "A"),
            ArtistModel(artistId: ArtistId(id: 3), primaryText: "C"),
        ])
        artistRepository.onFindByIds = {
            runOnMainActor { favoriteArtistRepository.add(artistId: ArtistId(id: 3)) }
        }
        let service = FavoriteArtistsService(
            favoriteArtistRepository: favoriteArtistRepository,
            artistRepository: artistRepository
        )

        _ = await service.findAll()

        #expect(favoriteArtistRepository.findAll().map { $0.id } == [1, 3])
    }
}
