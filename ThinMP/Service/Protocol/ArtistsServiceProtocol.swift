//
//  ArtistsServiceProtocol.swift
//  ThinMP
//
//  Created by tk on 2021/07/25.
//

protocol ArtistsServiceProtocol: Sendable {
    func findAll() async -> [ArtistModel]
}
