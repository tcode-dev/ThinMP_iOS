//
//  PlaylistsViewModel.swift
//  ThinMP
//
//  Created by tk on 2021/04/09.
//

import MediaPlayer

@MainActor
class PlaylistsViewModel: ObservableObject {
    @Published var playlists: [PlaylistModel] = []
    /// 登録モーダルで対象の曲がすでに入っているプレイリストの id
    @Published var registeredPlaylistIds: Set<String> = []

    private let playlistsService: PlaylistsServiceProtocol

    init(playlistsService: PlaylistsServiceProtocol = PlaylistsService()) {
        self.playlistsService = playlistsService
    }

    @discardableResult
    func load() -> Task<Void, Never> {
        Task {
            playlists = playlistsService.findAll()
        }
    }

    /// 登録モーダル用。一覧を 1 回読み、そこから songId がすでに登録されているプレイリストを求める
    @discardableResult
    func load(songId: SongId) -> Task<Void, Never> {
        Task {
            playlists = playlistsService.findAll()
            registeredPlaylistIds = Set(playlists.filter { $0.contains(songId: songId) }.map { $0.id })
        }
    }

    func isRegistered(playlistId: PlaylistId) -> Bool {
        return registeredPlaylistIds.contains(playlistId.id)
    }
}
