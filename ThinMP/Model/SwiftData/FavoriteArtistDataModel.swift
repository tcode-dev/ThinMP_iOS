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
