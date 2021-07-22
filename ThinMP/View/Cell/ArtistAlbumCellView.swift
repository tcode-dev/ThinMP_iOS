//
//  ArtistAlbumCell.swift
//  ThinMP
//
//  Created by tk on 2020/01/20.
//

import SwiftUI

struct ArtistAlbumCellView: View {
    let album: AlbumModel
    let size: CGFloat

    var body: some View {
        VStack {
            SquareImageView(artwork: album.artwork, size: size)
            PrimaryTextView(album.primaryText)
        }
        .padding(StyleConstant.Padding.small)
    }
}
