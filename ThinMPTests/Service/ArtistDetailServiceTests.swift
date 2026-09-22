//
//  ArtistDetailServiceTests.swift
//  ThinMPTests
//
//  Created by tk on 2026/09/22.
//

import Testing
@testable import ThinMP

struct ArtistDetailServiceTests {
    private let artistId = ArtistId(id: 10)
    private let album1 = AlbumModel(albumId: AlbumId(id: 1), primaryText: "A")
    private let album2 = AlbumModel(albumId: AlbumId(id: 2), primaryText: "B")

    private func makeService(artists: [ArtistModel], albums: [AlbumModel], albumSongs: [AlbumId: [SongModel]] = [:]) -> ArtistDetailService {
        return ArtistDetailService(
            artistRepository: ArtistRepositoryMock(artists: artists),
            albumRepository: AlbumRepositoryMock(albums: albums, artistAlbums: [artistId: albums]),
            songRepository: SongRepositoryMock(songs: [], albumSongs: albumSongs)
        )
    }

    @Test
    func findByIdComposesAlbumsAndSongs() throws {
        let service = makeService(
            artists: [ArtistModel(artistId: artistId, primaryText: "Artist")],
            albums: [album1, album2],
            albumSongs: [AlbumId(id: 1): [.fake(id: 11), .fake(id: 12)], AlbumId(id: 2): [.fake(id: 21)]]
        )

        let artist = try #require(service.findById(artistId: artistId))

        #expect(artist.primaryText == "Artist")
        #expect(artist.albums.map { $0.albumId.id } == [1, 2])
        // 曲はアルバムの順に並ぶ
        #expect(artist.songs.map { $0.songId.id } == [11, 12, 21])
    }

    @Test
    func findByIdReturnsNilWhenArtistIsMissing() {
        let service = makeService(artists: [], albums: [album1])

        #expect(service.findById(artistId: artistId) == nil)
    }

    @Test
    func findByIdsKeepsOrderAndLeavesAlbumsAndSongsEmpty() {
        let other = ArtistId(id: 20)
        let service = ArtistDetailService(
            artistRepository: ArtistRepositoryMock(artists: [ArtistModel(artistId: artistId, primaryText: "A"), ArtistModel(artistId: other, primaryText: "B")]),
            albumRepository: AlbumRepositoryMock(artistAlbums: [artistId: [album1]]),
            songRepository: SongRepositoryMock(songs: [])
        )

        let artists = service.findByIds(artistIds: [other, ArtistId(id: 99), artistId])

        #expect(artists.map { $0.artistId.id } == [20, 10])
        #expect(artists.map { $0.primaryText } == ["B", "A"])
        #expect(artists.allSatisfy { $0.albums.isEmpty && $0.songs.isEmpty })
    }
}
