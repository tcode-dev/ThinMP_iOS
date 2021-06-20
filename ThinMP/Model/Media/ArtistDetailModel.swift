//
//  ArtistDetailModel.swift
//  ThinMP
//
//  Created by tk on 2021/05/31.
//

import MediaPlayer

struct ArtistDetailModel: DetailProtocol {
    var artistId: ArtistId
    var primaryText: String?
    var secondaryText:String?
    var artwork: MPMediaItemArtwork?
    var albums: [AlbumModel]
    var songs: [SongModel]
    var id: String {
        return String(artistId.id)
    }
    var shortcutId: String {
        return String(artistId.id)
    }
}
