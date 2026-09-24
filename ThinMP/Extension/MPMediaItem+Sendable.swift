//
//  MPMediaItem+Sendable.swift
//  ThinMP
//
//  Created by tk on 2026/09/24.
//

import MediaPlayer

// MediaPlayer は Sendable に対応していないので、ライブラリの項目はそのままではバックグラウンドの Task から返せない
// どちらも作った後に中身を書き換えない読み取り専用のオブジェクトで、ライブラリはバックグラウンドで引いてメインアクターで表示しているので、
// 送れるものとして扱う
extension MPMediaItem: @retroactive @unchecked Sendable {}
extension MPMediaItemArtwork: @retroactive @unchecked Sendable {}
