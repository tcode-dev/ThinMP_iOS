//
//  SongsService.swift
//  ThinMP
//
//  Created by tk on 2021/06/07.
//

struct SongsService {
    func findAll() -> [SongModel] {
        let repository = SongRepository()

        return repository.findAll()
    }
}
