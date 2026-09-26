//
//  View+NavigationDestinations.swift
//  ThinMP
//
//  Created by tk on 2026/09/26.
//

import SwiftUI

extension View {
    /// 一覧の行やメニューの NavigationLink(value:) が遷移するページ
    /// NavigationStack の中のどのページからでも遷移できるように、ルートのページに付ける
    func navigationDestinations() -> some View {
        return navigationDestination(for: MainMenu.self) { menu in
            switch menu {
            case .artists: ArtistsPageView()
            case .albums: AlbumsPageView()
            case .songs: SongsPageView()
            case .favoriteArtists: FavoriteArtistsPageView()
            case .favoriteSongs: FavoriteSongsPageView()
            case .playlists: PlaylistsPageView()
            }
        }
        .navigationDestination(for: ArtistId.self) { artistId in
            ArtistDetailPageView(artistId: artistId)
        }
        .navigationDestination(for: AlbumId.self) { albumId in
            AlbumDetailPageView(albumId: albumId)
        }
        .navigationDestination(for: PlaylistId.self) { playlistId in
            PlaylistDetailPageView(playlistId: playlistId)
        }
        .navigationDestination(for: ShortcutTarget.self) { target in
            switch target {
            case .artist(let artistId): ArtistDetailPageView(artistId: artistId)
            case .album(let albumId): AlbumDetailPageView(albumId: albumId)
            case .playlist(let playlistId): PlaylistDetailPageView(playlistId: playlistId)
            }
        }
    }
}
