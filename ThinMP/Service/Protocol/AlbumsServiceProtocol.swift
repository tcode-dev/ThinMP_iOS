//
//  AlbumsServiceProtocol.swift
//  ThinMP
//
//  Created by tk on 2021/07/25.
//

nonisolated protocol AlbumsServiceProtocol: Sendable {
    @concurrent
    func findAll() async -> [AlbumModel]

    /// ショートカット用。結果は albumIds の順で、ライブラリに無いアルバムは落ちる
    @concurrent
    func findByIds(albumIds: [AlbumId]) async -> [AlbumModel]
}
