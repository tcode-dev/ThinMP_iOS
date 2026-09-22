//
//  MainMenu.swift
//  ThinMP
//
//  Created by tk on 2026/09/22.
//

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

    /// 表示名。Localizable.strings のキーで、LabelConstant の同名の値と同じ
    var label: String {
        return rawValue
    }
}
