//
//  PlaylistModel.swift
//  ThinMP
//
//  Created by tk on 2021/06/15.
//

import MediaPlayer

struct PlaylistModel: MediaProtocol, Identifiable {
    var playlistId: PlaylistId
    var primaryText: String?
    var secondaryText: String?
    var artwork: MPMediaItemArtwork?
    /// order 順。登録モーダルで「登録済み」を判定するのに使う
    var songIds: [SongId] = []
    var id: String {
        return playlistId.id
    }

    func contains(songId: SongId) -> Bool {
        return songIds.contains(songId)
    }
}
