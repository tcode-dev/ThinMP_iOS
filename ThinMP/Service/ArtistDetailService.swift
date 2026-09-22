//
//  ArtistDetailService.swift
//  ThinMP
//
//  Created by tk on 2021/05/31.
//

import MediaPlayer

struct ArtistDetailService: ArtistDetailServiceProtocol {
    private let artistRepository: ArtistRepositoryProtocol
    private let albumRepository: AlbumRepositoryProtocol
    private let songRepository: SongRepositoryProtocol

    init(
        artistRepository: ArtistRepositoryProtocol = ArtistRepository(),
        albumRepository: AlbumRepositoryProtocol = AlbumRepository(),
        songRepository: SongRepositoryProtocol = SongRepository()
    ) {
        self.artistRepository = artistRepository
        self.albumRepository = albumRepository
        self.songRepository = songRepository
    }

    func findById(artistId: ArtistId) -> ArtistDetailModel? {
        guard let artist = artistRepository.findById(artistId: artistId) else {
            return nil
        }

        let albums = albumRepository.findByArtistId(artistId: artistId)
        // 曲は 1 回のクエリで引き、アルバムの並び順に揃える(アルバムごとに引くとアルバム数分クエリが走る)
        let songsByAlbum = Dictionary(grouping: songRepository.findByArtistId(artistId: artistId)) { $0.albumId }
        let songs = albums.flatMap { songsByAlbum[$0.albumId] ?? [] }

        return ArtistDetailModel(artistId: artist.artistId, primaryText: artist.primaryText, artwork: artwork(albums: albums), albums: albums, songs: songs)
    }

    /// ショートカット用。アートワークのためにアルバムは引くが、albums / songs は空のまま
    func findByIds(artistIds: [ArtistId]) -> [ArtistDetailModel] {
        return artistRepository.findByIds(artistIds: artistIds).map { artist in
            let albums = albumRepository.findByArtistId(artistId: artist.artistId)

            return ArtistDetailModel(artistId: artist.artistId, primaryText: artist.primaryText, artwork: artwork(albums: albums), albums: [], songs: [])
        }
    }

    /// アーティスト自身はアートワークを持たないので、アルバムの中で最初に見つかったものを使う
    private func artwork(albums: [AlbumModel]) -> MPMediaItemArtwork? {
        return albums.first { $0.artwork != nil }?.artwork
    }
}
