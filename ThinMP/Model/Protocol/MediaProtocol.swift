//
//  MediaProtocol.swift
//  ThinMP
//
//  Created by tk on 2021/05/04.
//

import MediaPlayer

protocol MediaProtocol {
    var persistentId: MPMediaEntityPersistentID? { get }
    var primaryText: String? { get }
    var secondaryText: String? { get }
    var artwork: MPMediaItemArtwork? { get }
}

extension MediaProtocol {
    var id: String? {
        return nil
    }
    var persistentId: MPMediaEntityPersistentID? {
        return nil
    }
    var primaryText: String? {
        return primaryText
    }
    var secondaryText: String? {
        return nil
    }
    var artwork: MPMediaItemArtwork? {
        return nil
    }
}
