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

    /// ライブラリ全件を取るのでバックグラウンドで行う
    func findAll() async -> [ArtistModel] {
        return await Task.detached(priority: .userInitiated) { [repository] in
            repository.findAll()
        }.value
    }
}
