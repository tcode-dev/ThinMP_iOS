//
//  PlaylistRegisterViewModel.swift
//  ThinMP
//
//  Created by tk on 2026/09/23.
//

import Observation

/// 曲をプレイリストに登録するモーダル
/// 曲がすでに登録されているかは、View が各プレイリストの songIds から判定する
@Observable
final class PlaylistRegisterViewModel {
    /// 読み込む前は nil。空の配列なら「プレイリストが 1 つも無い」
    private(set) var playlists: [PlaylistModel]?

    private let playlistsService: PlaylistsServiceProtocol
    private let playlistRepository: PlaylistRepositoryProtocol
    private let loadTask = LoadTask()

    init(
        playlistsService: PlaylistsServiceProtocol = PlaylistsService(),
        playlistRepository: PlaylistRepositoryProtocol = PlaylistRepository()
    ) {
        self.playlistsService = playlistsService
        self.playlistRepository = playlistRepository
    }

    func load() async {
        await loadTask.run {
            await playlistsService.findAll()
        } apply: { playlists in
            self.playlists = playlists
        }
    }

    /// 曲 1 つを入れた新しいプレイリストを作る
    /// 読み込みを待たずに押せるので、playlists が nil でも作る
    func create(songId: SongId, name: String) {
        playlistRepository.create(songId: songId, name: name)
    }

    /// 既存のプレイリストに曲を入れる
    func add(playlistId: PlaylistId, songId: SongId) {
        playlistRepository.add(playlistId: playlistId, songId: songId)
    }
}
