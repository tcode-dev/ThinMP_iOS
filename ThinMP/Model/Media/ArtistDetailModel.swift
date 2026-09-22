//
//  ArtistDetailModel.swift
//  ThinMP
//
//  Created by tk on 2021/05/31.
//

import MediaPlayer

/// 説明("%d albums, %d songs")は albums / songs の数から View が組み立てる
struct ArtistDetailModel: MediaProtocol {
    var artistId: ArtistId
    var primaryText: String?
    var artwork: MPMediaItemArtwork?
    var albums: [AlbumModel]
    var songs: [SongModel]
}
