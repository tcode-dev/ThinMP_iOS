//
//  FavoriteArtistsServiceTests.swift
//  ThinMPTests
//
//  Created by tk on 2026/09/21.
//

import Testing
@testable import ThinMP

struct FavoriteArtistsServiceTests {
    @Test
    func returnsArtistsInFavoriteOrder() {
        let favoriteArtistRepository = FavoriteArtistRepositoryMock(artistIds: [ArtistId(id: 3), ArtistId(id: 1)])
        let artistRepository = ArtistRepositoryMock(artists: [
            ArtistModel(artistId: ArtistId(id: 1), primaryText: "A"),
            ArtistModel(artistId: ArtistId(id: 2), primaryText: "B"),
            ArtistModel(artistId: ArtistId(id: 3), primaryText: "C"),
        ])
        let service = FavoriteArtistsService(
            favoriteArtistRepository: favoriteArtistRepository,
            artistRepository: artistRepository,
            favoriteArtistRegister: FavoriteArtistRegister(repository: favoriteArtistRepository)
        )

        let artists = service.findAll()

        #expect(artists.map { $0.primaryText } == ["C", "A"])
        #expect(favoriteArtistRepository.updateCalls.isEmpty)
    }

    @Test
    func removesArtistsMissingFromLibrary() {
        let favoriteArtistRepository = FavoriteArtistRepositoryMock(artistIds: [ArtistId(id: 1), ArtistId(id: 2), ArtistId(id: 3)])
        let artistRepository = ArtistRepositoryMock(artists: [
            ArtistModel(artistId: ArtistId(id: 1), primaryText: "A"),
            ArtistModel(artistId: ArtistId(id: 3), primaryText: "C"),
        ])
        let service = FavoriteArtistsService(
            favoriteArtistRepository: favoriteArtistRepository,
            artistRepository: artistRepository,
            favoriteArtistRegister: FavoriteArtistRegister(repository: favoriteArtistRepository)
        )

        let artists = service.findAll()

        #expect(artists.map { $0.artistId.id } == [1, 3])
        #expect(favoriteArtistRepository.updateCalls.count == 1)
        #expect(favoriteArtistRepository.updateCalls[0].map { $0.id } == [1, 3])
    }
}
