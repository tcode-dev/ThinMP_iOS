//
//  AlbumDetailServiceTests.swift
//  ThinMPTests
//
//  Created by tk on 2026/09/22.
//

import Testing
@testable import ThinMP

struct AlbumDetailServiceTests {
    private let album1 = AlbumModel(albumId: AlbumId(id: 1), primaryText: "A", secondaryText: "Artist")
    private let album2 = AlbumModel(albumId: AlbumId(id: 2), primaryText: "B")

    @Test
    func findByIdComposesAlbumAndSongs() throws {
        let service = AlbumDetailService(
            albumRepository: AlbumRepositoryMock(albums: [album1, album2]),
            songRepository: SongRepositoryMock(songs: [], albumSongs: [AlbumId(id: 1): [.fake(id: 11), .fake(id: 12)]])
        )

        let album = try #require(service.findById(albumId: AlbumId(id: 1)))

        #expect(album.primaryText == "A")
        #expect(album.secondaryText == "Artist")
        #expect(album.songs.map { $0.songId.id } == [11, 12])
    }

    @Test
    func findByIdReturnsNilWhenAlbumIsMissing() {
        let service = AlbumDetailService(albumRepository: AlbumRepositoryMock(albums: [album1]), songRepository: SongRepositoryMock(songs: []))

        #expect(service.findById(albumId: AlbumId(id: 99)) == nil)
    }

    @Test
    func findByIdsKeepsOrderAndLeavesSongsEmpty() {
        let service = AlbumDetailService(
            albumRepository: AlbumRepositoryMock(albums: [album1, album2]),
            songRepository: SongRepositoryMock(songs: [], albumSongs: [AlbumId(id: 1): [.fake(id: 11)]])
        )

        let albums = service.findByIds(albumIds: [AlbumId(id: 2), AlbumId(id: 99), AlbumId(id: 1)])

        #expect(albums.map { $0.albumId.id } == [2, 1])
        #expect(albums.allSatisfy { $0.songs.isEmpty })
    }
}
