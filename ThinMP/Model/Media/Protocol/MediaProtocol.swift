//
//  MediaProtocol.swift
//  ThinMP
//
//  Created by tk on 2021/05/04.
//

import MediaPlayer

nonisolated protocol MediaProtocol {
    var primaryText: String? { get }
    var secondaryText: String? { get }
    var artwork: MPMediaItemArtwork? { get }
}

nonisolated extension MediaProtocol {
    var secondaryText: String? {
        return nil
    }

    var artwork: MPMediaItemArtwork? {
        return nil
    }
}

nonisolated extension Sequence where Element: MediaProtocol {
    /// 最初に見つかったアートワーク。無ければ nil
    /// アーティストやプレイリストは自身がアートワークを持たないので、アルバムや曲から借りるのに使う
    var firstArtwork: MPMediaItemArtwork? {
        return first { $0.artwork != nil }?.artwork
    }
}
