//
//  ShortcutTarget.swift
//  ThinMP
//
//  Created by tk on 2026/09/22.
//

/// ショートカットが指す先。種別と id の組み合わせを型で保証する
nonisolated enum ShortcutTarget: Hashable {
    case artist(ArtistId)
    case album(AlbumId)
    case playlist(PlaylistId)
}

nonisolated extension ShortcutTarget {
    /// ストアの行から作る
    /// type が不明な行と、アーティスト / アルバムなのに itemId が persistentID として読めない行は nil にして落とす
    init?(itemId: String, type rawType: Int) {
        switch ShortcutType(rawValue: rawType) {
        case .artist:
            guard let id = UInt64(itemId) else {
                return nil
            }

            self = .artist(ArtistId(id: id))
        case .album:
            guard let id = UInt64(itemId) else {
                return nil
            }

            self = .album(AlbumId(id: id))
        case .playlist:
            self = .playlist(PlaylistId(id: itemId))
        case nil:
            return nil
        }
    }

    /// ストアに保存する種別
    var type: ShortcutType {
        switch self {
        case .artist: return .artist
        case .album: return .album
        case .playlist: return .playlist
        }
    }

    /// ストアに保存する id。アーティスト / アルバムは persistentID を文字列にしたもの、プレイリストは PlaylistId
    var itemId: String {
        switch self {
        case .artist(let artistId): return String(artistId.id)
        case .album(let albumId): return String(albumId.id)
        case .playlist(let playlistId): return playlistId.id
        }
    }
}
