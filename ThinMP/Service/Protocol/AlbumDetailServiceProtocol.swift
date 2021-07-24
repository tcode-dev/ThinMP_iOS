//
//  AlbumDetailServiceProtocol.swift
//  ThinMP
//
//  Created by tk on 2021/07/25.
//

protocol AlbumDetailServiceProtocol {
    func findById(albumId: AlbumId) -> AlbumDetailModel?

    func findByIds(albumIds: [AlbumId]) -> [AlbumDetailModel]
}
