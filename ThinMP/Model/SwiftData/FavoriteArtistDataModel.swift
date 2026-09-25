//
//  FavoriteArtistDataModel.swift
//  ThinMP
//
//  Created by tk on 2026/09/21.
//

import Foundation
import SwiftData

@Model
final class FavoriteArtistDataModel {
    var id: String
    var artistId: String
    var order: Int

    init(id: String = UUID().uuidString, artistId: String, order: Int) {
        self.id = id
        self.artistId = artistId
        self.order = order
    }
}

extension FavoriteArtistDataModel: FavoriteDataModel {
    static var orderKey: KeyPath<FavoriteArtistDataModel, Int> & Sendable {
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
