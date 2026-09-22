//
//  MainServiceProtocol.swift
//  ThinMP
//
//  Created by tk on 2021/07/25.
//

@MainActor
protocol MainServiceProtocol {
    func findRecentlyAlbums() async -> [AlbumModel]

    func findShortcuts() async -> [ShortcutModel]

    func getSettings() -> MainSettings

    func save(settings: MainSettings)
}
