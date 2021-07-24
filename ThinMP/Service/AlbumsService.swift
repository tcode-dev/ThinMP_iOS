//
//  AlbumsService.swift
//  ThinMP
//
//  Created by tk on 2021/06/07.
//

struct AlbumsService: AlbumsServiceProtocol {
    func findAll() -> [AlbumModel] {
        let repository = AlbumRepository()

        return repository.findAll()
    }
}
