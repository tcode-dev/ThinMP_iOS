//
//  AlbumDetailServiceProtocol.swift
//  ThinMP
//
//  Created by tk on 2021/07/25.
//

protocol AlbumDetailServiceProtocol: Sendable {
    func findById(albumId: AlbumId) async -> AlbumDetailModel?
}
