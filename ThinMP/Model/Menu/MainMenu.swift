//
//  MainMenu.swift
//  ThinMP
//
//  Created by tk on 2026/09/22.
//

import Foundation

/// メインページに並ぶライブラリのメニュー
/// rawValue は並び順と表示 / 非表示のキーとして UserDefaults に保存されているので変更しない
/// allCases の順が初期状態の並び順
enum MainMenu: String, CaseIterable {
    case artists = "Artists"
    case albums = "Albums"
    case songs = "Songs"
    case favoriteArtists = "FavoriteArtists"
    case favoriteSongs = "FavoriteSongs"
    case playlists = "Playlists"

    /// 表示名。rawValue はストアのキーなので、表示には使わない
    var label: LocalizedStringResource {
        switch self {
        case .artists: return .artists
        case .albums: return .albums
        case .songs: return .songs
        case .favoriteArtists: return .favoriteArtists
        case .favoriteSongs: return .favoriteSongs
        case .playlists: return .playlists
        }
    }
}
