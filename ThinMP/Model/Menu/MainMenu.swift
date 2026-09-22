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

    /// 表示名。Localizable.strings のキー
    /// rawValue と同じ文字列だが、あちらはストアのキーなので LabelConstant を単一の出どころにする
    var label: String {
        switch self {
        case .artists: return LabelConstant.artists
        case .albums: return LabelConstant.albums
        case .songs: return LabelConstant.songs
        case .favoriteArtists: return LabelConstant.favoriteArtists
        case .favoriteSongs: return LabelConstant.favoriteSongs
        case .playlists: return LabelConstant.playlists
        }
    }
}
