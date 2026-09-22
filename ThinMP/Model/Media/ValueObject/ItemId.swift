//
//  ItemId.swift
//  ThinMP
//
//  Created by tk on 2021/06/25.
//

/// ショートカットが指す先の id。アーティスト / アルバムは persistentID を文字列にしたもの、プレイリストは PlaylistId
/// アーティスト / アルバムの itemId が数値であることは ShortcutEntity.init?(id:itemId:type:) で保証している
struct ItemId: Hashable {
    var id: String
    var artistId: ArtistId {
        return ArtistId(id: UInt64(id)!)
    }

    var albumId: AlbumId {
        return AlbumId(id: UInt64(id)!)
    }

    var playlistId: PlaylistId {
        return PlaylistId(id: id)
    }
}

extension ItemId {
    init(artistId: ArtistId) {
        self.init(id: String(artistId.id))
    }

    init(albumId: AlbumId) {
        self.init(id: String(albumId.id))
    }

    init(playlistId: PlaylistId) {
        self.init(id: playlistId.id)
    }
}
