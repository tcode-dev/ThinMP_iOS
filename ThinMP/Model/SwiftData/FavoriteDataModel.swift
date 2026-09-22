//
//  FavoriteDataModel.swift
//  ThinMP
//
//  Created by tk on 2026/09/23.
//

import Foundation
import SwiftData

/// お気に入り(アーティスト、曲)のモデルが満たす契約。FavoriteRepository がこれだけを使って読み書きする
/// mediaId のプロパティ名はストアに保存されているのでモデルごとに違う。
/// #Predicate と SortDescriptor は保存されているプロパティを直接指す必要があるので、
/// 引き当てと並び替えのキーはモデル側から渡す
protocol FavoriteDataModel: PersistentModel {
    static var orderKey: KeyPath<Self, Int> { get }

    var mediaId: String { get }
    var order: Int { get set }

    init(mediaId: String, order: Int)

    static func predicate(mediaId: String) -> Predicate<Self>
}

extension FavoriteArtistDataModel: FavoriteDataModel {
    static var orderKey: KeyPath<FavoriteArtistDataModel, Int> {
        return \.order
    }

    var mediaId: String {
        return artistId
    }

    convenience init(mediaId: String, order: Int) {
        self.init(artistId: mediaId, order: order)
    }

    static func predicate(mediaId: String) -> Predicate<FavoriteArtistDataModel> {
        return #Predicate { $0.artistId == mediaId }
    }
}

extension FavoriteSongDataModel: FavoriteDataModel {
    static var orderKey: KeyPath<FavoriteSongDataModel, Int> {
        return \.order
    }

    var mediaId: String {
        return songId
    }

    convenience init(mediaId: String, order: Int) {
        self.init(songId: mediaId, order: order)
    }

    static func predicate(mediaId: String) -> Predicate<FavoriteSongDataModel> {
        return #Predicate { $0.songId == mediaId }
    }
}
