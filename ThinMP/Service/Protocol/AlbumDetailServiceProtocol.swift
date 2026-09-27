//
//  AlbumDetailServiceProtocol.swift
//  ThinMP
//
//  Created by tk on 2021/07/25.
//

nonisolated protocol AlbumDetailServiceProtocol: Sendable {
    @concurrent
    func findById(albumId: AlbumId) async -> AlbumDetailModel?
}
