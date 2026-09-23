//
//  SongModelTests.swift
//  ThinMPTests
//
//  Created by tk on 2026/09/23.
//

import Testing
@testable import ThinMP

struct SongModelTests {
    @Test
    func sortedByTrackOrdersByDiscThenTrack() {
        let songs: [SongModel] = [
            .fake(id: 1, disc: 2, track: 1),
            .fake(id: 2, disc: 1, track: 2),
            .fake(id: 3, disc: 1, track: 1),
            .fake(id: 4, disc: 2, track: 3),
        ]

        #expect(songs.sortedByTrack().map { $0.songId.id } == [3, 2, 1, 4])
    }

    /// トラック番号の無い曲(0)どうしは、元の並び(曲名順)のまま
    @Test
    func sortedByTrackKeepsTheOrderOfSongsWithTheSameNumber() {
        let songs: [SongModel] = [.fake(id: 1), .fake(id: 2), .fake(id: 3, track: 1), .fake(id: 4)]

        #expect(songs.sortedByTrack().map { $0.songId.id } == [1, 2, 4, 3])
    }
}
