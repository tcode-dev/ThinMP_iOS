//
//  FavoriteArtistsService.swift
//  ThinMP
//
//  Created by tk on 2021/06/07.
//

struct FavoriteArtistsService: FavoriteArtistsServiceProtocol {
    func findAll() -> [ArtistModel] {
        let favoriteArtistRepository = FavoriteArtistRepository()
        let artistIds = favoriteArtistRepository.findAll()
        let artistRepository = ArtistRepository()
        let artists = artistRepository.findByIds(artistIds: artistIds)

        if !validation(artistIds: artistIds, artists: artists) {
            fix(artists: artists)

            return findAll()
        }

        return artists
    }

    private func validation(artistIds: [ArtistId], artists: [ArtistModel]) -> Bool {
        return artistIds.count == artists.count
    }

    private func fix(artists: [ArtistModel]) {
        let favoriteArtistRegister = FavoriteArtistRegister()
        let artistIds = artists.map { $0.artistId }

        favoriteArtistRegister.update(artistIds: artistIds)
    }
}
