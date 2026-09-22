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
}

extension ArtistModel {
    /// MPMediaQuery.artists() のコレクションから作る。代表アイテムが無いコレクションは nil
    init?(collection: MPMediaItemCollection) {
        guard let item = collection.representativeItem else {
            return nil
        }

        self.init(artistId: ArtistId(id: item.artistPersistentID), primaryText: item.artist)
    }
}
