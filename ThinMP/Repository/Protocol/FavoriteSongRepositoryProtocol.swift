//
//  FavoriteSongRepositoryProtocol.swift
//  ThinMP
//
//  Created by tk on 2021/07/25.
//

protocol FavoriteSongRepositoryProtocol {
    func findAll() -> [SongId]

    func exists(songId: SongId) -> Bool

    func add(songId: SongId)

    func update(songIds: [SongId])

    func delete(songId: SongId)
}

extension FavoriteSongRepositoryProtocol {
    /// 登録済みなら外し、未登録なら入れる。切り替えたあとの登録状態を返す
    @discardableResult
    func toggle(songId: SongId) -> Bool {
        if exists(songId: songId) {
            delete(songId: songId)

            return false
        }

        add(songId: songId)

        return true
    }
}
