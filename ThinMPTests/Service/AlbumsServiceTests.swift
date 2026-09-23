//
//  AlbumsServiceTests.swift
//  ThinMPTests
//
//  Created by tk on 2026/09/23.
//

import Testing
@testable import ThinMP

struct AlbumsServiceTests {
    private let album1 = AlbumModel(albumId: AlbumId(id: 1), primaryText: "A", secondaryText: nil, artwork: nil)
    private let album2 = AlbumModel(albumId: AlbumId(id: 2), primaryText: "B", secondaryText: nil, artwork: nil)

    @Test
    func findByIdsKeepsOrderAndDropsMissing() async {
        let service = AlbumsService(repository: AlbumRepositoryMock(albums: [album1, album2]))

        let albums = await service.findByIds(albumIds: [AlbumId(id: 2), AlbumId(id: 99), AlbumId(id: 1)])

        #expect(albums.map { $0.albumId.id } == [2, 1])
    }
}
