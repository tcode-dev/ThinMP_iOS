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

    /// ライブラリ全件を取るのでバックグラウンドで行う
    func findAll() async -> [AlbumModel] {
        return await Task.detached(priority: .userInitiated) { [repository] in
            repository.findAll()
        }.value
    }
}
