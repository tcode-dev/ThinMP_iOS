//
//  FavoriteArtistsService.swift
//  ThinMP
//
//  Created by tk on 2021/06/07.
//

struct FavoriteArtistsService: FavoriteArtistsServiceProtocol {
    private let favoriteArtistRepository: FavoriteArtistRepositoryProtocol
    private let artistRepository: ArtistRepositoryProtocol
    private let favoriteArtistRegister: FavoriteArtistRegisterProtocol

    init(
        favoriteArtistRepository: FavoriteArtistRepositoryProtocol = FavoriteArtistRepository(),
        artistRepository: ArtistRepositoryProtocol = ArtistRepository(),
        favoriteArtistRegister: FavoriteArtistRegisterProtocol = FavoriteArtistRegister()
    ) {
        self.favoriteArtistRepository = favoriteArtistRepository
        self.artistRepository = artistRepository
        self.favoriteArtistRegister = favoriteArtistRegister
    }

    func findAll() async -> [ArtistModel] {
        let artistIds = favoriteArtistRepository.findAll()
        // ライブラリ全件を舐めるので、SwiftData の読み書きだけメインアクターに残してスキャンはバックグラウンドで行う
        let artists = await Task.detached(priority: .userInitiated) { [artistRepository] in
            artistRepository.findByIds(artistIds: artistIds)
        }.value

        // 端末から削除されたアーティストがお気に入りに残っている場合は取り除いて保存する
        if artists.count != artistIds.count {
            favoriteArtistRegister.update(artistIds: artists.map { $0.artistId })
        }

        return artists
    }
}
