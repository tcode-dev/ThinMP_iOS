//
//  PlaylistsService.swift
//  ThinMP
//
//  Created by tk on 2021/06/07.
//

struct PlaylistsService: PlaylistsServiceProtocol {
    private let playlistDetailService: PlaylistDetailServiceProtocol

    init(playlistDetailService: PlaylistDetailServiceProtocol = PlaylistDetailService()) {
        self.playlistDetailService = playlistDetailService
    }

    func findAll() async -> [PlaylistModel] {
        // プレイリストごとに findById を呼ぶとライブラリ全件取得がその回数だけ走るので、まとめて 1 回で解決する
        return await playlistDetailService.findAll().map { playlist in
            PlaylistModel(playlistId: playlist.playlistId, primaryText: playlist.primaryText, artwork: playlist.artwork, songIds: playlist.songs.map { $0.songId })
        }
    }
}
