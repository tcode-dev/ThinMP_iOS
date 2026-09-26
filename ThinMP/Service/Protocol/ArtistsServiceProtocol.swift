//
//  ArtistsServiceProtocol.swift
//  ThinMP
//
//  Created by tk on 2021/07/25.
//

nonisolated protocol ArtistsServiceProtocol: Sendable {
    func findAll() async -> [ArtistModel]
}
