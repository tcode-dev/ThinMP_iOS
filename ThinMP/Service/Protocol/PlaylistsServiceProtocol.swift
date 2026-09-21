//
//  PlaylistsServiceProtocol.swift
//  ThinMP
//
//  Created by tk on 2021/07/25.
//

@MainActor
protocol PlaylistsServiceProtocol {
    func findAll() -> [PlaylistModel]
}
