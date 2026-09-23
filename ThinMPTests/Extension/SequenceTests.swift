//
//  SequenceTests.swift
//  ThinMPTests
//
//  Created by tk on 2026/09/22.
//

import Testing
@testable import ThinMP

struct SequenceTests {
    @Test
    func keyedLooksUpElementsById() {
        let songs = [SongModel.fake(id: 1), .fake(id: 2)]

        let keyed = songs.keyed { $0.songId }

        #expect(keyed.count == 2)
        #expect(keyed[SongId(id: 2)]?.songId.id == 2)
        #expect(keyed[SongId(id: 99)] == nil)
    }

    @Test
    func keyedKeepsTheFirstOfDuplicateIds() {
        let songs = [SongModel.fake(id: 1, title: "first"), .fake(id: 1, title: "second")]

        #expect(songs.keyed { $0.songId }[SongId(id: 1)]?.primaryText == "first")
    }

    @Test
    func keyedOfEmptyIsEmpty() {
        #expect([SongModel]().keyed { $0.songId }.isEmpty)
    }

    @Test
    func uniquedKeepsFirstOccurrenceAndOrder() {
        #expect([3, 1, 3, 2, 1].uniqued() == [3, 1, 2])
        #expect([SongId(id: 2), SongId(id: 1), SongId(id: 2)].uniqued() == [SongId(id: 2), SongId(id: 1)])
    }

    @Test
    func uniquedOfEmptyIsEmpty() {
        #expect([Int]().uniqued().isEmpty)
    }
}
