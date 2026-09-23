//
//  AlbumModel.swift
//  ThinMP
//
//  Created by tk on 2019/10/28.
//

import MediaPlayer

struct AlbumModel: MediaProtocol, Identifiable {
    let albumId: AlbumId
    let primaryText: String?
    let secondaryText: String?
    let artwork: MPMediaItemArtwork?
    var id: AlbumId {
        return albumId
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
