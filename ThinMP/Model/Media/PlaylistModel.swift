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
    var artwork: MPMediaItemArtwork?
    /// order 順。登録モーダルが「登録済み」を判定するのに使う(PlaylistRegisterViewModel.registeredPlaylistIds)
    var songIds: [SongId] = []
    var id: String {
        return playlistId.id
    }
}
