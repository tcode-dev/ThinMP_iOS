//
//  SongModel.swift
//  ThinMP
//
//  Created by tk on 2021/05/04.
//

import MediaPlayer

/// ライブラリの曲 1 件。再生キューに入れるので MPMediaItem をそのまま持つ
struct SongModel: MediaProtocol, Identifiable {
    let item: MPMediaItem

    var id: SongId {
        return songId
    }

    var songId: SongId {
        return SongId(id: item.persistentID)
    }

    var artistId: ArtistId {
        return ArtistId(id: item.artistPersistentID)
    }

    var albumId: AlbumId {
        return AlbumId(id: item.albumPersistentID)
    }

    var primaryText: String? {
        return item.title
    }

    var secondaryText: String? {
        return item.artist
    }

    var artwork: MPMediaItemArtwork? {
        return item.artwork
    }
}

extension Sequence<SongModel> {
    /// アルバムの曲順(ディスク番号、トラック番号の順)。番号が同じ曲は元の並びのまま
    /// MPMediaItem のプロパティ取得は安くないので、比較のたびに引かずに 1 回だけ取る
    func sortedByTrack() -> [SongModel] {
        return enumerated()
            .map { (song: $1, disc: $1.item.discNumber, track: $1.item.albumTrackNumber, index: $0) }
            .sorted { ($0.disc, $0.track, $0.index) < ($1.disc, $1.track, $1.index) }
            .map { $0.song }
    }
}
