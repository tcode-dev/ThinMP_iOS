//
//  ArtistsServiceProtocol.swift
//  ThinMP
//
//  Created by tk on 2021/07/25.
//

nonisolated protocol ArtistsServiceProtocol: Sendable {
    @concurrent
    func findAll() async -> [ArtistModel]
}
