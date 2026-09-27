//
//  ArtistsViewModelTests.swift
//  ThinMPTests
//
//  Created by tk on 2026/09/23.
//

import Testing
@testable import ThinMP

@MainActor
struct ArtistsViewModelTests {
    @Test
    func loadPublishesArtistsFromService() async {
        let service = ArtistsServiceMock(artists: [
            ArtistModel(artistId: ArtistId(id: 1), primaryText: "A"),
            ArtistModel(artistId: ArtistId(id: 2), primaryText: "B"),
        ])
        let vm = ArtistsViewModel(artistsService: service)

        await vm.load()

        #expect(vm.artists.map { $0.artistId.id } == [1, 2])
        #expect(service.findAllCalls == 1)
    }
}
