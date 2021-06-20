//
//  FavoriteArtistsService.swift
//  ThinMP
//
//  Created by tk on 2021/06/07.
//

struct FavoriteArtistsService {
    func findAll() -> [ArtistModel] {
        let favoriteArtistRepository = FavoriteArtistRepository()
        let artistIds = favoriteArtistRepository.findAll()
        let artistRepository = ArtistRepository()

        return artistRepository.findByIds(artistIds: artistIds)
    }
}
