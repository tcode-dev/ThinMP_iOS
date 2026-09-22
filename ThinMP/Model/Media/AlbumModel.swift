//
//  AlbumModel.swift
//  ThinMP
//
//  Created by tk on 2019/10/28.
//

import MediaPlayer

struct AlbumModel: MediaProtocol, Identifiable {
    var albumId: AlbumId
    var primaryText: String?
    var secondaryText: String?
    var artwork: MPMediaItemArtwork?
    var id: String {
        return String(albumId.id)
    }
}

extension AlbumModel {
    /// MPMediaQuery.albums() のコレクションから作る。代表アイテムが無いコレクションは nil
    init?(collection: MPMediaItemCollection) {
        guard let item = collection.representativeItem else {
            return nil
        }

        self.init(albumId: AlbumId(id: item.albumPersistentID), primaryText: item.albumTitle, secondaryText: item.artist, artwork: item.artwork)
    }
}
