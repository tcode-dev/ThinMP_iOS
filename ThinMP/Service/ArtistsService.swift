//
//  ArtistsService.swift
//  ThinMP
//
//  Created by tk on 2021/06/07.
//

struct ArtistsService: ArtistsServiceProtocol {
    private let repository: ArtistRepositoryProtocol

    init(repository: ArtistRepositoryProtocol = ArtistRepository()) {
        self.repository = repository
    }

    func findAll() -> [ArtistModel] {
        return repository.findAll()
    }
}
