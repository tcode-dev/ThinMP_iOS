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

    /// 編集ページのショートカットの並び順と削除を保存する
    func update(shortcutIds: [ShortcutId])
}
