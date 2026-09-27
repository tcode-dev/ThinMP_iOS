//
//  SongsViewModelTests.swift
//  ThinMPTests
//
//  Created by tk on 2026/09/22.
//

import Testing
@testable import ThinMP

@MainActor
struct SongsViewModelTests {
    @Test
    func loadPublishesSongsFromService() async {
        let service = SongsServiceMock(songs: [.fake(id: 1), .fake(id: 2)])
        let vm = SongsViewModel(songsService: service)

        await vm.load()

        #expect(vm.songs.map { $0.songId.id } == [1, 2])
        #expect(service.findAllCalls == 1)
    }
}
