//
//  SwiftUIView.swift
//  ThinMP
//
//  Created by tk on 2020/01/13.
//

import SwiftUI
import MediaPlayer

struct SongRowView: View {
    private let size: CGFloat = 40

    let song: MPMediaItemCollection

    var body: some View {
        HStack {
            SquareImageView(artwork: self.song.representativeItem?.artwork, size: size)
            VStack(alignment: .leading) {
                PrimaryTextView(song.representativeItem?.title)
                SecondaryTextView(song.representativeItem?.artist)
            }
            Spacer()
        }
    }
}
