//
//  FavoriteArtistsViewModelTests.swift
//  ThinMPTests
//
//  Created by tk on 2026/09/23.
//

import Testing
@testable import ThinMP

@MainActor
struct FavoriteArtistsViewModelTests {
    @Test
    func loadPublishesArtistsFromService() async {
        let service = FavoriteArtistsServiceMock(artists: [
            ArtistModel(artistId: ArtistId(id: 2), primaryText: "B"),
            ArtistModel(artistId: ArtistId(id: 1), primaryText: "A"),
        ])
        let vm = FavoriteArtistsViewModel(favoriteArtistsService: service)

        #expect(vm.artists == nil)

        await vm.load()

        #expect(vm.artists?.map { $0.artistId.id } == [2, 1])
    }

    @Test
    func saveWritesEditedOrderToRepository() async {
        let repository = FavoriteArtistRepositoryMock(artistIds: [ArtistId(id: 1), ArtistId(id: 2)])
        let service = FavoriteArtistsServiceMock(artists: [
            ArtistModel(artistId: ArtistId(id: 1), primaryText: "A"),
            ArtistModel(artistId: ArtistId(id: 2), primaryText: "B"),
        ])
        let vm = FavoriteArtistsViewModel(favoriteArtistsService: service, favoriteArtistRepository: repository)

        await vm.load()
        vm.artists?.move(fromOffsets: [1], toOffset: 0)
        vm.save()

        #expect(repository.updateCalls.map { $0.map { $0.id } } == [[2, 1]])
        #expect(repository.findAll().map { $0.id } == [2, 1])
    }

    /// 読み込みが終わる前に完了を押しても、空の一覧でお気に入りを上書きしない
    @Test
    func saveBeforeLoadDoesNotTouchRepository() {
        let repository = FavoriteArtistRepositoryMock(artistIds: [ArtistId(id: 1), ArtistId(id: 2)])
        let vm = FavoriteArtistsViewModel(favoriteArtistsService: FavoriteArtistsServiceMock(artists: []), favoriteArtistRepository: repository)

        #expect(vm.artists == nil)
        vm.save()

        #expect(repository.updateCalls.isEmpty)
        #expect(repository.findAll().map { $0.id } == [1, 2])
    }
}
