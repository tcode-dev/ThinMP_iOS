//
//  AlbumsServiceProtocol.swift
//  ThinMP
//
//  Created by tk on 2021/07/25.
//

protocol AlbumsServiceProtocol {
    func findAll() async -> [AlbumModel]

    /// ショートカット用。結果は albumIds の順で、ライブラリに無いアルバムは落ちる
    func findByIds(albumIds: [AlbumId]) async -> [AlbumModel]
}
