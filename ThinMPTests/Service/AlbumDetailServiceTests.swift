//
//  AlbumDetailServiceTests.swift
//  ThinMPTests
//
//  Created by tk on 2026/09/22.
//

import Testing
@testable import ThinMP

struct AlbumDetailServiceTests {
    private let album1 = AlbumModel(albumId: AlbumId(id: 1), primaryText: "A", secondaryText: "Artist", artwork: nil)
    private let album2 = AlbumModel(albumId: AlbumId(id: 2), primaryText: "B", secondaryText: nil, artwork: nil)

    @Test
    func findByIdComposesAlbumAndSongs() async throws {
        let service = AlbumDetailService(
            albumRepository: AlbumRepositoryMock(albums: [album1, album2]),
            songRepository: SongRepositoryMock(songs: [], albumSongs: [AlbumId(id: 1): [.fake(id: 11), .fake(id: 12)]])
        )

        let album = try #require(await service.findById(albumId: AlbumId(id: 1)))

        #expect(album.primaryText == "A")
        #expect(album.secondaryText == "Artist")
        #expect(album.songs.map { $0.songId.id } == [11, 12])
    }

    @Test
    func findByIdReturnsNilWhenAlbumIsMissing() async {
        let service = AlbumDetailService(albumRepository: AlbumRepositoryMock(albums: [album1]), songRepository: SongRepositoryMock(songs: []))

        #expect(await service.findById(albumId: AlbumId(id: 99)) == nil)
    }
}
