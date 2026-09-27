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
    func secondLoadDropsStaleResultOfFirst() async {
        let service = BlockingFavoriteSongsServiceMock()
        let vm = FavoriteSongsViewModel(favoriteSongsService: service)

        let first = Task { await vm.load() }
        await Task.yield()
        let second = Task { await vm.load() }
        await Task.yield()
        #expect(service.pendingCount == 2)

        // 古い方が先に完了しても、後から始めた読み込みがあるので結果は捨てられる
        service.resume(with: [.fake(id: 1)])
        await first.value
        #expect(vm.songs == nil)

        // 新しい方の結果だけが反映される
        service.resume(with: [.fake(id: 2)])
        await second.value
        #expect(vm.songs?.map { $0.songId.id } == [2])
    }

    /// View の .task が打ち切られたときのように、呼び出し元が打ち切られたら結果は捨てる
    @Test
    func cancelledLoadDropsResult() async {
        let service = BlockingFavoriteSongsServiceMock()
        let vm = FavoriteSongsViewModel(favoriteSongsService: service)

        let task = Task { await vm.load() }
        await Task.yield()
        #expect(service.pendingCount == 1)

        task.cancel()
        service.resume(with: [.fake(id: 1)])
        await task.value

        #expect(vm.songs == nil)
    }

    @Test
    func saveWritesEditedOrderToRepository() async {
        let repository = FavoriteSongRepositoryMock(songIds: [SongId(id: 1), SongId(id: 2), SongId(id: 3)])
        let service = FavoriteSongsServiceMock(songs: [.fake(id: 1), .fake(id: 2), .fake(id: 3)])
        let vm = FavoriteSongsViewModel(favoriteSongsService: service, favoriteSongRepository: repository)

        await vm.load()
        vm.songs?.remove(atOffsets: [1])
        vm.songs?.move(fromOffsets: [1], toOffset: 0)
        vm.save()

        #expect(repository.updateCalls.map { $0.map { $0.id } } == [[3, 1]])
        #expect(repository.findAll().map { $0.id } == [3, 1])
    }

    /// 読み込みが終わる前に完了を押しても、空の一覧でお気に入りを上書きしない
    @Test
    func saveBeforeLoadDoesNotTouchRepository() async {
        let repository = FavoriteSongRepositoryMock(songIds: [SongId(id: 1), SongId(id: 2)])
        let service = BlockingFavoriteSongsServiceMock()
        let vm = FavoriteSongsViewModel(favoriteSongsService: service, favoriteSongRepository: repository)

        let task = Task { await vm.load() }
        await Task.yield()
        #expect(vm.songs == nil)

        vm.save()

        #expect(repository.updateCalls.isEmpty)
        #expect(repository.findAll().map { $0.id } == [1, 2])

        service.resume(with: [.fake(id: 1), .fake(id: 2)])
        await task.value

        #expect(vm.songs != nil)
    }
}
