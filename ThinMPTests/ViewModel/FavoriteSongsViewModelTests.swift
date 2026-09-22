//
//  FavoriteSongsViewModelTests.swift
//  ThinMPTests
//
//  Created by tk on 2026/09/22.
//

import Testing
@testable import ThinMP

@MainActor
struct FavoriteSongsViewModelTests {
    @Test
    func secondLoadCancelsFirstSoStaleResultIsDropped() async {
        let service = BlockingFavoriteSongsServiceMock()
        let vm = FavoriteSongsViewModel(favoriteSongsService: service)

        let first = vm.load()
        await Task.yield()
        let second = vm.load()
        await Task.yield()
        #expect(service.pendingCount == 2)

        // 古い方が先に完了しても、打ち切られているので結果は捨てられる
        service.resume(with: [.fake(id: 1)])
        await first.value
        #expect(vm.songs.isEmpty)

        // 新しい方の結果だけが反映される
        service.resume(with: [.fake(id: 2)])
        await second.value
        #expect(vm.songs.map { $0.songId.id } == [2])
    }

    @Test
    func saveWritesEditedOrder() async {
        let service = FavoriteSongsServiceMock(songs: [.fake(id: 1), .fake(id: 2), .fake(id: 3)])
        let vm = FavoriteSongsViewModel(favoriteSongsService: service)

        await vm.load().value
        vm.songs.remove(atOffsets: [1])
        vm.songs.move(fromOffsets: [1], toOffset: 0)
        vm.save()

        #expect(service.updateCalls.map { $0.map { $0.id } } == [[3, 1]])
    }
}

@MainActor
struct FavoriteArtistsViewModelTests {
    @Test
    func saveWritesEditedOrder() async {
        let service = FavoriteArtistsServiceMock(artists: [
            ArtistModel(artistId: ArtistId(id: 1), primaryText: "A"),
            ArtistModel(artistId: ArtistId(id: 2), primaryText: "B"),
        ])
        let vm = FavoriteArtistsViewModel(favoriteArtistsService: service)

        await vm.load().value
        vm.artists.move(fromOffsets: [1], toOffset: 0)
        vm.save()

        #expect(service.updateCalls.map { $0.map { $0.id } } == [[2, 1]])
    }
}
