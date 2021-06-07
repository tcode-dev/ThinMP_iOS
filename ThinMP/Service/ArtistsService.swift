//
//  ArtistsService.swift
//  ThinMP
//
//  Created by tk on 2021/06/07.
//

struct ArtistsService {
    func findAll() -> [ArtistModel] {
        let repository = ArtistRepository()

        return repository.findAll()
    }
}
