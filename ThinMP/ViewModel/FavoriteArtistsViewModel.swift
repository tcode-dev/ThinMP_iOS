//
//  FavoriteArtistsViewModel.swift
//  ThinMP
//
//  Created by tk on 2021/01/02.
//

import Combine

@MainActor
final class FavoriteArtistsViewModel: ObservableObject {
    @Published var artists: [ArtistModel] = []
    /// 1 回目の読み込みが終わったか。終わるまでは編集ページの保存を受け付けない
    @Published private(set) var isLoaded = false

    private let favoriteArtistsService: FavoriteArtistsServiceProtocol
    private let favoriteArtistRepository: FavoriteArtistRepositoryProtocol
    private let loadTask = LoadTask()

    init(
        favoriteArtistsService: FavoriteArtistsServiceProtocol = FavoriteArtistsService(),
        favoriteArtistRepository: FavoriteArtistRepositoryProtocol = FavoriteArtistRepository()
    ) {
        self.favoriteArtistsService = favoriteArtistsService
        self.favoriteArtistRepository = favoriteArtistRepository
    }

    @discardableResult
    func load() -> Task<Void, Never> {
        return loadTask.run { [favoriteArtistsService] in
            await favoriteArtistsService.findAll()
        } apply: { [weak self] artists in
            self?.artists = artists
            self?.isLoaded = true
        }
    }

    /// 編集ページの並び順と削除を保存する
    /// 読み込み前に呼ばれたら何もしない(空の artists で上書きするとお気に入りが全部消える)
    func save() {
        guard isLoaded else {
            return
        }

        favoriteArtistRepository.update(artistIds: artists.map { $0.artistId })
    }
}
