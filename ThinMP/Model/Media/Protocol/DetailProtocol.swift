//
//  DetailProtocol.swift
//  ThinMP
//
//  Created by tk on 2021/06/01.
//

import MediaPlayer

protocol DetailProtocol {
    var id: String { get }
    var primaryText: String? { get }
    var secondaryText: String? { get }
    var artwork: MPMediaItemArtwork? { get }
    var shortcutId: String { get }
}
