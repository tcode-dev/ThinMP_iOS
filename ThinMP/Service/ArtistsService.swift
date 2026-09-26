//
//  ArtistsService.swift
//  ThinMP
//
//  Created by tk on 2021/06/07.
//

nonisolated struct ArtistsService: ArtistsServiceProtocol {
    private let repository: ArtistRepositoryProtocol

    init(repository: ArtistRepositoryProtocol = ArtistRepository()) {
        self.repository = repository
    }

    /// ライブラリ全件を取るのでバックグラウンドで行う
    @concurrent
    func findAll() async -> [ArtistModel] {
        return repository.findAll()
    }
}
