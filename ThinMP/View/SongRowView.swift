//
//  SwiftUIView.swift
//  ThinMP
//
//  Created by tk on 2020/01/13.
//

import SwiftUI

struct SongRowView: View {
    var song: Song
    var size: CGFloat = 40

    var body: some View {
        HStack {
            SquareImageView(artwork: self.song.artwork, size: size)
            VStack(alignment: .leading) {
                PrimaryTextView(song.title)
                SecondaryTextView(song.artist)
            }
            Spacer()
        }
    }
}
