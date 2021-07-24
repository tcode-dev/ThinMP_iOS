//
//  MainServiceProtocol.swift
//  ThinMP
//
//  Created by tk on 2021/07/25.
//

protocol MainServiceProtocol {
    func findRecentlyAlbums() -> [AlbumModel]

    func findShortcuts() -> [ShortcutModel]

    func getMainMenus() -> [MenuModel]

    func getShortcutMenu() -> MenuModel

    func getRecentlyMenu() -> MenuModel
}
