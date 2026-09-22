//
//  AlbumDetailService.swift
//  ThinMP
//
//  Created by tk on 2021/06/01.
//

struct AlbumDetailService: AlbumDetailServiceProtocol {
    private let albumRepository: AlbumRepositoryProtocol
    private let songRepository: SongRepositoryProtocol

    init(
        albumRepository: AlbumRepositoryProtocol = AlbumRepository(),
        songRepository: SongRepositoryProtocol = SongRepository()
    ) {
        self.albumRepository = albumRepository
        self.songRepository = songRepository
    }

    func findById(albumId: AlbumId) -> AlbumDetailModel? {
        guard let album = albumRepository.findById(albumId: albumId) else {
            return nil
        }

        let songs = songRepository.findByAlbumId(albumId: albumId)

        return AlbumDetailModel(albumId: album.albumId, primaryText: album.primaryText, secondaryText: album.secondaryText, artwork: album.artwork, songs: songs)
    }

    func findByIds(albumIds: [AlbumId]) -> [AlbumDetailModel] {
        return albumRepository.findByIds(albumIds: albumIds).map { album in
            AlbumDetailModel(albumId: album.albumId, primaryText: album.primaryText, secondaryText: album.secondaryText, artwork: album.artwork, songs: [])
        }
    }
}
