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

    /// ライブラリを引くのでバックグラウンドで行う
    func findById(artistId: ArtistId) async -> ArtistDetailModel? {
        return await Task.detached(priority: .userInitiated) { [artistRepository, albumRepository, songRepository] in
            guard let artist = artistRepository.findById(artistId: artistId) else {
                return nil
            }

            let albums = albumRepository.findByArtistId(artistId: artistId)
            // 曲は 1 回のクエリで引き、アルバムの並び順に揃える(アルバムごとに引くとアルバム数分クエリが走る)
            let songsByAlbum = Dictionary(grouping: songRepository.findByArtistId(artistId: artistId)) { $0.albumId }
            let songs = albums.flatMap { songsByAlbum[$0.albumId] ?? [] }

            return ArtistDetailModel(artistId: artist.artistId, primaryText: artist.primaryText, artwork: Self.artwork(albums: albums), albums: albums, songs: songs)
        }.value
    }

    /// ショートカット用。アートワークのためにアルバムは引くが、albums / songs は空のまま
    /// ライブラリ全件を走査するのでバックグラウンドで行う
    ///
    /// findById と違ってアーティストごとにクエリを投げる。ライブラリを 1 回走査して
    /// 代表アイテムの artistPersistentID で振り分けると、findByArtistId が拾うコンピレーション盤が漏れて
    /// ショートカットの画像が変わってしまうため。件数はショートカットの数までに限られるので、
    /// クエリを減らす利得より画像が変わる影響の方が大きい
    func findByIds(artistIds: [ArtistId]) async -> [ArtistDetailModel] {
        return await Task.detached(priority: .userInitiated) { [artistRepository, albumRepository] in
            artistRepository.findByIds(artistIds: artistIds).map { artist in
                let albums = albumRepository.findByArtistId(artistId: artist.artistId)

                return ArtistDetailModel(artistId: artist.artistId, primaryText: artist.primaryText, artwork: Self.artwork(albums: albums), albums: [], songs: [])
            }
        }.value
    }

    /// アーティスト自身はアートワークを持たないので、アルバムの中で最初に見つかったものを使う
    private static func artwork(albums: [AlbumModel]) -> MPMediaItemArtwork? {
        return albums.first { $0.artwork != nil }?.artwork
    }
}
