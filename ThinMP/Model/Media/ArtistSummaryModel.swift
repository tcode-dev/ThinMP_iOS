//
//  ArtistSummaryModel.swift
//  ThinMP
//
//  Created by tk on 2026/09/23.
//

import MediaPlayer

/// アーティストの名前とアートワーク。アルバムと曲は持たない
/// ショートカットのように、詳細までは要らないがアートワークは出したいところで使う
nonisolated struct ArtistSummaryModel: MediaProtocol {
    let artistId: ArtistId
    let primaryText: String?
    let artwork: MPMediaItemArtwork?
}
