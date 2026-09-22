//
//  PlaylistDetailModel.swift
//  ThinMP
//
//  Created by tk on 2021/05/30.
//

import MediaPlayer

/// 説明は「プレイリスト」のラベル固定なので持たず、View が出す
struct PlaylistDetailModel: MediaProtocol {
    var playlistId: PlaylistId
    var primaryText: String?
    var artwork: MPMediaItemArtwork?
    var songs: [SongModel] = []
}
