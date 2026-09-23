//
//  PlaylistModel.swift
//  ThinMP
//
//  Created by tk on 2021/06/15.
//

import MediaPlayer

struct PlaylistModel: MediaProtocol, Identifiable {
    let playlistId: PlaylistId
    let primaryText: String?
    let artwork: MPMediaItemArtwork?
    /// order 順。登録モーダルが曲の「登録済み」を判定するのに使う(PlaylistRegisterView)
    let songIds: [SongId]
    var id: PlaylistId {
        return playlistId
    }
}
