//
//  SongsService.swift
//  ThinMP
//
//  Created by tk on 2021/06/07.
//

struct SongsService: SongsServiceProtocol {
    private let repository: SongRepositoryProtocol

    init(repository: SongRepositoryProtocol = SongRepository()) {
        self.repository = repository
    }

    func findAll() -> [SongModel] {
        return repository.findAll()
    }
}
