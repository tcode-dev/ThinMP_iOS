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
    func reorderedFollowsIdsAndDropsWhatIsNotInThem() {
        let songs = [SongModel.fake(id: 1), .fake(id: 2), .fake(id: 3)]

        let reordered = songs.reordered(by: [SongId(id: 3), SongId(id: 1)]) { $0.songId }

        #expect(reordered.map { $0.songId.id } == [3, 1])
    }

    @Test
    func reorderedSkipsIdsThatAreNotInTheSequence() {
        let songs = [SongModel.fake(id: 1)]

        let reordered = songs.reordered(by: [SongId(id: 99), SongId(id: 1)]) { $0.songId }

        #expect(reordered.map { $0.songId.id } == [1])
    }

    @Test
    func reorderedKeepsTheFirstOfDuplicateIds() {
        let songs = [SongModel.fake(id: 1, title: "first"), .fake(id: 1, title: "second")]

        let reordered = songs.reordered(by: [SongId(id: 1)]) { $0.songId }

        #expect(reordered.map { $0.primaryText } == ["first"])
    }

    @Test
    func reorderedWithEmptyIdsIsEmpty() {
        #expect([SongModel.fake(id: 1)].reordered(by: []) { $0.songId }.isEmpty)
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
