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
    private let album1 = AlbumModel(albumId: AlbumId(id: 1), primaryText: "A", secondaryText: nil, artwork: nil)
    private let album2 = AlbumModel(albumId: AlbumId(id: 2), primaryText: "B", secondaryText: nil, artwork: nil)

    private func makeService(artists: [ArtistModel], albums: [AlbumModel], songs: [SongModel] = []) -> ArtistDetailService {
        return ArtistDetailService(
            artistRepository: ArtistRepositoryMock(artists: artists),
            albumRepository: AlbumRepositoryMock(albums: albums, artistAlbums: [artistId: albums]),
            songRepository: SongRepositoryMock(songs: songs)
        )
    }

    /// 曲はライブラリの順ではなく、アルバムの順にまとめ直す
    @Test
    func findByIdComposesAlbumsAndSongsInAlbumOrder() async throws {
        let service = makeService(
            artists: [ArtistModel(artistId: artistId, primaryText: "Artist")],
            albums: [album1, album2],
            songs: [.fake(id: 21, artistId: 10, albumId: 2), .fake(id: 11, artistId: 10, albumId: 1), .fake(id: 12, artistId: 10, albumId: 1)]
        )

        let artist = try #require(await service.findById(artistId: artistId))

        #expect(artist.primaryText == "Artist")
        #expect(artist.albums.map { $0.albumId.id } == [1, 2])
        #expect(artist.songs.map { $0.songId.id } == [11, 12, 21])
    }

    @Test
    func findByIdReturnsNilWhenArtistIsMissing() async {
        let service = makeService(artists: [], albums: [album1])

        #expect(await service.findById(artistId: artistId) == nil)
    }

    @Test
    func findByIdsKeepsOrder() async {
        let other = ArtistId(id: 20)
        let service = ArtistDetailService(
            artistRepository: ArtistRepositoryMock(artists: [ArtistModel(artistId: artistId, primaryText: "A"), ArtistModel(artistId: other, primaryText: "B")]),
            albumRepository: AlbumRepositoryMock(artistAlbums: [artistId: [album1]]),
            songRepository: SongRepositoryMock(songs: [])
        )

        let artists = await service.findByIds(artistIds: [other, ArtistId(id: 99), artistId])

        #expect(artists.map { $0.artistId.id } == [20, 10])
        #expect(artists.map { $0.primaryText } == ["B", "A"])
    }
}
