//
//  FavoriteArtistsService.swift
//  ThinMP
//
//  Created by tk on 2021/06/07.
//

struct FavoriteArtistsService: FavoriteArtistsServiceProtocol {
    private let favoriteArtistRepository: FavoriteArtistRepositoryProtocol
    private let artistRepository: ArtistRepositoryProtocol

    init(
        favoriteArtistRepository: FavoriteArtistRepositoryProtocol = FavoriteArtistRepository(),
        artistRepository: ArtistRepositoryProtocol = ArtistRepository()
    ) {
        self.favoriteArtistRepository = favoriteArtistRepository
        self.artistRepository = artistRepository
    }

    func findAll() async -> [ArtistModel] {
        let artistIds = favoriteArtistRepository.findAll()
        // ライブラリ全件を走査するので、SwiftData の読み書きだけメインアクターに残してスキャンはバックグラウンドで行う
        let (artists, deletedIds) = await Self.findArtists(artistIds: artistIds, artistRepository: artistRepository)

        // 端末から削除されたアーティストがお気に入りに残っている場合は、そのアーティストだけ取り除く
        // クラウドにしか無いアーティスト(端末から外されただけのもの)は一覧には出さないが、ダウンロードし直せば戻るように残す
        // 一覧ごと上書きすると、走査中に(再生画面などで)登録されたアーティストまで消える
        for artistId in artistIds where deletedIds.contains(artistId) {
            favoriteArtistRepository.delete(artistId: artistId)
        }

        return artists
    }

    /// 見つかったアーティストと、見つからなかったアーティストのうちクラウドにも無いもの。ライブラリを走査するのでバックグラウンドで行う
    @concurrent
    private static func findArtists(artistIds: [ArtistId], artistRepository: ArtistRepositoryProtocol) async -> ([ArtistModel], Set<ArtistId>) {
        let artists = artistRepository.findByIds(artistIds: artistIds)
        let foundIds = Set(artists.map { $0.artistId })

        return (artists, artistRepository.findDeletedIds(artistIds: artistIds.filter { !foundIds.contains($0) }))
    }
}
