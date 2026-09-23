//
//  ArtistDetailModel.swift
//  ThinMP
//
//  Created by tk on 2021/05/31.
//

import MediaPlayer

/// 説明("%d albums, %d songs")は albums / songs の数から View が組み立てる
struct ArtistDetailModel {
    let artistId: ArtistId
    let primaryText: String?
    let artwork: MPMediaItemArtwork?
    let albums: [AlbumModel]
    let songs: [SongModel]
}
