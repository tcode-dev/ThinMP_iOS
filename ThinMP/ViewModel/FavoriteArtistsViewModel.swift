//
//  FavoriteArtistsViewModel.swift
//  ThinMP
//
//  Created by tk on 2021/01/02.
//

import Observation

@Observable
final class FavoriteArtistsViewModel {
    /// 読み込む前は nil。編集ページは nil のあいだ保存を受け付けない
    var artists: [ArtistModel]?

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
        }
    }

    /// 編集ページの並び順と削除を保存する
    /// 読み込み前に呼ばれたら何もしない(空の一覧で上書きするとお気に入りが全部消える)
    func save() {
        guard let artists else {
            return
        }

        favoriteArtistRepository.update(artistIds: artists.map { $0.artistId })
    }
}
