//
//  AlbumsServiceProtocol.swift
//  ThinMP
//
//  Created by tk on 2021/07/25.
//

protocol AlbumsServiceProtocol: Sendable {
    func findAll() async -> [AlbumModel]

    /// ショートカット用。結果は albumIds の順で、ライブラリに無いアルバムは落ちる
    func findByIds(albumIds: [AlbumId]) async -> [AlbumModel]

    /// ショートカット用。albumIds のうち、クラウドにしか無いアルバムも含めてライブラリに無いもの(AlbumRepositoryProtocol.findDeletedIds)
    func findDeletedIds(albumIds: [AlbumId]) async -> Set<AlbumId>
}
