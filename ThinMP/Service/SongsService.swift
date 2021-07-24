//
//  SongsService.swift
//  ThinMP
//
//  Created by tk on 2021/06/07.
//

struct SongsService: SongsServiceProtocol {
    func findAll() -> [SongModel] {
        let repository = SongRepository()

        return repository.findAll()
    }
}
