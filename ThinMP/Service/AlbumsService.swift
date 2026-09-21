//
//  AlbumsService.swift
//  ThinMP
//
//  Created by tk on 2021/06/07.
//

struct AlbumsService: AlbumsServiceProtocol {
    private let repository: AlbumRepositoryProtocol

    init(repository: AlbumRepositoryProtocol = AlbumRepository()) {
        self.repository = repository
    }

    func findAll() -> [AlbumModel] {
        return repository.findAll()
    }
}
