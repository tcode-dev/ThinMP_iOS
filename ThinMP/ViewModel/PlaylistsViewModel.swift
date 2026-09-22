//
//  PlaylistsViewModel.swift
//  ThinMP
//
//  Created by tk on 2021/04/09.
//

import Combine

@MainActor
class PlaylistsViewModel: ObservableObject {
    @Published var playlists: [PlaylistModel] = []
    /// 登録モーダルで対象の曲がすでに入っているプレイリストの id
    @Published var registeredPlaylistIds: Set<PlaylistId> = []

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

    /// songId は登録モーダル用。一覧を 1 回読み、そこから songId がすでに登録されているプレイリストを求める
    @discardableResult
    func load(songId: SongId? = nil) -> Task<Void, Never> {
        return loadTask.run { [playlistsService] in
            await playlistsService.findAll()
        } apply: { [weak self] playlists in
            self?.playlists = playlists
            self?.registeredPlaylistIds = songId.map { songId in Set(playlists.filter { $0.contains(songId: songId) }.map { $0.playlistId }) } ?? []
        }
    }

    func isRegistered(playlistId: PlaylistId) -> Bool {
        return registeredPlaylistIds.contains(playlistId)
    }

    /// 編集ページの並び順と削除を保存する
    func save() {
        playlistRepository.update(playlistIds: playlists.map { $0.playlistId })
    }

    /// 登録モーダルで曲 1 つを入れた新しいプレイリストを作る
    func create(songId: SongId, name: String) {
        playlistRepository.create(songId: songId, name: name)
    }

    /// 登録モーダルで既存のプレイリストに曲を入れる
    func add(playlistId: PlaylistId, songId: SongId) {
        playlistRepository.add(playlistId: playlistId, songId: songId)
    }

    /// 一覧のコンテキストメニューから削除して読み直す
    func delete(playlistId: PlaylistId) {
        playlistRepository.delete(playlistId: playlistId)
        load()
    }
}
