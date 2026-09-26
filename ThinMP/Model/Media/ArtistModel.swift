//
//  ArtistModel.swift
//  ThinMP
//
//  Created by tk on 2020/01/06.
//

import MediaPlayer

nonisolated struct ArtistModel: MediaProtocol, Identifiable {
    let artistId: ArtistId
    let primaryText: String?
    var id: ArtistId {
        return artistId
    }
}

nonisolated extension ArtistModel {
    /// MPMediaQuery.artists() のコレクションから作る。代表アイテムが無いコレクションは nil
    init?(collection: MPMediaItemCollection) {
        guard let item = collection.representativeItem else {
            return nil
        }

        self.init(artistId: ArtistId(id: item.artistPersistentID), primaryText: item.artist)
    }
}
