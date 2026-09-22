//
//  DetailProtocol.swift
//  ThinMP
//
//  Created by tk on 2021/06/01.
//

import MediaPlayer

/// 詳細ページのモデル。id はショートカットの itemId と同じ文字列
protocol DetailProtocol {
    var id: String { get }
    var primaryText: String? { get }
    var secondaryText: String? { get }
    var artwork: MPMediaItemArtwork? { get }
}
