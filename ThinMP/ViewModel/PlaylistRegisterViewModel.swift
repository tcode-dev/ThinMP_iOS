//
//  PlaylistRegisterViewModel.swift
//  ThinMP
//
//  Created by tk on 2026/09/23.
//

import Combine

/// 曲をプレイリストに登録するモーダル
/// 一覧を 1 回読み、そこから songId がすでに登録されているプレイリストを求める
@MainActor
class PlaylistRegisterViewModel: ObservableObject {
    @Published private(set) var playlists: [PlaylistModel] = []
    /// 対象の曲がすでに入っているプレイリストの id
    @Published private(set) var registeredPlaylistIds: Set<PlaylistId> = []

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

    @discardableResult
    func load(songId: SongId) -> Task<Void, Never> {
        return loadTask.run { [playlistsService] in
            await playlistsService.findAll()
        } apply: { [weak self] playlists in
            self?.playlists = playlists
            self?.registeredPlaylistIds = Set(playlists.filter { $0.contains(songId: songId) }.map { $0.playlistId })
        }
    }

    func isRegistered(playlistId: PlaylistId) -> Bool {
        return registeredPlaylistIds.contains(playlistId)
    }

    /// 曲 1 つを入れた新しいプレイリストを作る
    /// 読み込みを待たずに押せるので、isLoaded のようなガードは置かない
    func create(songId: SongId, name: String) {
        playlistRepository.create(songId: songId, name: name)
    }

    /// 既存のプレイリストに曲を入れる
    func add(playlistId: PlaylistId, songId: SongId) {
        playlistRepository.add(playlistId: playlistId, songId: songId)
    }
}
