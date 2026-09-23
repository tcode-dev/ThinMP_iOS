//
//  PlaylistDetailModel.swift
//  ThinMP
//
//  Created by tk on 2021/05/30.
//

import MediaPlayer

/// 説明は「プレイリスト」のラベル固定なので持たず、View が出す
struct PlaylistDetailModel: MediaProtocol {
    let playlistId: PlaylistId
    let primaryText: String?
    let artwork: MPMediaItemArtwork?
    var songs: [SongModel]
}
