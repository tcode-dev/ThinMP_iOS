//
//  ArtistModel.swift
//  ThinMP
//
//  Created by tk on 2020/01/06.
//

import MediaPlayer

struct ArtistModel: MediaProtocol, Identifiable {
    var artistId: ArtistId
    var primaryText: String?
    var id: String {
        return String(artistId.id)
    }
    var shortcutId: String {
        return String(artistId.id)
    }
}
