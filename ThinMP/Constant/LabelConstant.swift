//
//  LabelConstant.swift
//  ThinMP
//
//  Created by tk on 2021/06/11.
//

enum LabelConstant {
    static let library: String = "Library"
    static let artists: String = "Artists"
    static let albums: String = "Albums"
    static let songs: String = "Songs"
    static let favoriteArtists: String = "Favorite Artists"
    static let favoriteSongs: String = "Favorite Songs"
    static let playlists: String = "Playlists"
    static let shortcuts: String = "Shortcuts"
    static let recentlyAdded: String = "Recently Added"
}
extension LabelConstant {
    enum MenuType: String, CaseIterable {
        case artists
        case albums
        case songs
        case favoriteArtists
        case favoriteSongs
        case playlists
    }
}
