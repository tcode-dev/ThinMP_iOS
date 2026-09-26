//
//  SongsService.swift
//  ThinMP
//
//  Created by tk on 2021/06/07.
//

nonisolated struct SongsService: SongsServiceProtocol {
    private let repository: SongRepositoryProtocol

    init(repository: SongRepositoryProtocol = SongRepository()) {
        self.repository = repository
    }

    /// ライブラリ全件を取るのでバックグラウンドで行う
    func findAll() async -> [SongModel] {
        return await Task.detached(priority: .userInitiated) { [repository] in
            repository.findAll()
        }.value
    }
}
