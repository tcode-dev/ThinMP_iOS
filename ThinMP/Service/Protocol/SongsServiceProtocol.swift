//
//  SongsServiceProtocol.swift
//  ThinMP
//
//  Created by tk on 2021/07/25.
//

protocol SongsServiceProtocol: Sendable {
    func findAll() async -> [SongModel]
}
