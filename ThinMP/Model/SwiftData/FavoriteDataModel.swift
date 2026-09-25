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
    static var orderKey: KeyPath<Self, Int> & Sendable { get }

    var mediaId: String { get }

    init(mediaId: String, order: Int)

    static func predicate(mediaId: String) -> Predicate<Self>
}
