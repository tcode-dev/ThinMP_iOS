//
//  AlbumsService.swift
//  ThinMP
//
//  Created by tk on 2021/06/07.
//

nonisolated struct AlbumsService: AlbumsServiceProtocol {
    private let repository: AlbumRepositoryProtocol

    init(repository: AlbumRepositoryProtocol = AlbumRepository()) {
        self.repository = repository
    }

    /// ライブラリ全件を取るのでバックグラウンドで行う
    @concurrent
    func findAll() async -> [AlbumModel] {
        return repository.findAll()
    }

    /// ライブラリ全件を走査するのでバックグラウンドで行う
    @concurrent
    func findByIds(albumIds: [AlbumId]) async -> [AlbumModel] {
        return repository.findByIds(albumIds: albumIds)
    }

    /// ライブラリ全件を走査するのでバックグラウンドで行う
    @concurrent
    func findDeletedIds(albumIds: [AlbumId]) async -> Set<AlbumId> {
        return repository.findDeletedIds(albumIds: albumIds)
    }
}
