//
//  PlaylistsService.swift
//  ThinMP
//
//  Created by tk on 2021/06/07.
//

struct PlaylistsService: PlaylistsServiceProtocol {
    private let playlistRepository: PlaylistRepositoryProtocol
    private let playlistRegister: PlaylistRegisterProtocol
    private let playlistDetailService: PlaylistDetailServiceProtocol

    init(
        playlistRepository: PlaylistRepositoryProtocol = PlaylistRepository(),
        playlistRegister: PlaylistRegisterProtocol = PlaylistRegister(),
        playlistDetailService: PlaylistDetailServiceProtocol = PlaylistDetailService()
    ) {
        self.playlistRepository = playlistRepository
        self.playlistRegister = playlistRegister
        self.playlistDetailService = playlistDetailService
    }

    func findAll() async -> [PlaylistModel] {
        let playlistIds = playlistRepository.findAll().map { $0.playlistId }

        // プレイリストごとに findById を呼ぶとライブラリ全件取得がその回数だけ走るので、まとめて 1 回で解決する
        return await playlistDetailService.findByIds(playlistIds: playlistIds).map { playlist in
            PlaylistModel(playlistId: playlist.playlistId, primaryText: playlist.primaryText, artwork: playlist.artwork, songIds: playlist.songs.map { $0.songId })
        }
    }

    func create(songId: SongId, name: String) {
        playlistRegister.create(songId: songId, name: name)
    }

    func add(playlistId: PlaylistId, songId: SongId) {
        playlistRegister.add(playlistId: playlistId, songId: songId)
    }

    func update(playlistIds: [PlaylistId]) {
        playlistRegister.update(playlistIds: playlistIds)
    }

    func delete(playlistId: PlaylistId) {
        playlistRegister.delete(playlistId: playlistId)
    }
}
