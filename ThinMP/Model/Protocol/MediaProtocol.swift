//
//  MediaProtocol.swift
//  ThinMP
//
//  Created by tk on 2021/05/04.
//

import MediaPlayer

protocol MediaProtocol {
    var primaryText: String? { get }
    var secondaryText: String? { get }
    var artwork: MPMediaItemArtwork? { get }
}

extension MediaProtocol {
    var secondaryText: String? {
        return nil
    }
    var artwork: MPMediaItemArtwork? {
        return nil
    }
}
