//
//  ArtistSongRowView.swift
//  ThinMP
//
//  Created by tk on 2020/01/20.
//

import SwiftUI

struct ArtistSongRowView: View {
    var song: Song
    var size: CGFloat = 40

    var body: some View {
        HStack {
            SquareImageView(artwork: self.song.artwork, size: size)
            PrimaryTextView(song.title)
            Spacer()
        }
    }
}
