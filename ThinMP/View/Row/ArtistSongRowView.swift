//
//  ArtistSongRowView.swift
//  ThinMP
//
//  Created by tk on 2020/01/20.
//

import SwiftUI

struct ArtistSongRowView: View {
    var song: Song
    var cgSize: CGSize = CGSize(width: 40, height: 40)
    var body: some View {
        HStack {
            SquareImageView(artwork: self.song.artwork, cgSize: cgSize).frame(width: 40)
            PrimaryTextView(song.title)
            Spacer()
        }
    }
}
