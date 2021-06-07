//
//  FavoriteArtistsService.swift
//  ThinMP
//
//  Created by tk on 2021/06/07.
//

struct FavoriteArtistsService {
    func findAll() -> [ArtistModel] {
        let favoriteArtistRepository = FavoriteArtistRepository()
        let persistentIds = favoriteArtistRepository.findAll()
        let artistRepository = ArtistRepository()

        return artistRepository.findByIds(persistentIds: persistentIds)
    }
}
