//
//  SongsServiceProtocol.swift
//  ThinMP
//
//  Created by tk on 2021/07/25.
//

nonisolated protocol SongsServiceProtocol: Sendable {
    @concurrent
    func findAll() async -> [SongModel]
}
