//
//  Image+Artwork.swift
//  ThinMP
//
//  Created by tk on 2026/09/22.
//

import MediaPlayer
import SwiftUI

extension Image {
    /// アートワークを size で描画する。無ければ placeholder のアセット画像、それも無ければ空
    /// アートワークのデコードはここで 1 箇所にまとめる
    init(artwork: MPMediaItemArtwork?, size: CGSize, placeholder: String? = nil) {
        let image = artwork?.image(at: size) ?? placeholder.map { UIImage(imageLiteralResourceName: $0) } ?? UIImage()

        self.init(uiImage: image)
    }
}
