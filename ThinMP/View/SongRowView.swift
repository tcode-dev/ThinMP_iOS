//
//  SwiftUIView.swift
//  ThinMP
//
//  Created by tk on 2020/01/13.
//

import SwiftUI

struct SongRowView: View {
    var song: Song
    var cgSize: CGSize = CGSize(width: 40, height: 40)
    var body: some View {
        HStack {
            SquareImageView(artwork: self.song.artwork, cgSize: cgSize).frame(width: 40)
            VStack(alignment: .leading) {
                PrimaryTextView(song.title)
                SecondaryTextView(song.artist)
            }
            Spacer()
        }
    }
}
