//
//  AlbumCellView.swift
//  ThinMP
//
//  Created by tk on 2020/01/12.
//

import SwiftUI

struct AlbumCellView: View {
    let album: AlbumModel
    let size: CGFloat

    var body: some View {
        VStack {
            SquareImageView(artwork: self.album.artwork, size: size)
            PrimaryTextView(self.album.primaryText)
            SecondaryTextView(self.album.secondaryText)
        }
        .padding(StyleConstant.Padding.medium)
    }
}
