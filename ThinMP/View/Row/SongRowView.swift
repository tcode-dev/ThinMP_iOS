//
//  SwiftUIView.swift
//  ThinMP
//
//  Created by tk on 2020/01/13.
//

import SwiftUI
import MediaPlayer

struct SongRowView: View {
    var song: MPMediaItemCollection
    var size: CGFloat = 40
    
    var body: some View {
        HStack {
            Button(action: {
                let musicService = MusicService.sharedInstance()
                musicService.start(itemCollection: self.song)
            }) {
                HStack {
                    SquareImageView(artwork: self.song.representativeItem?.artwork, size: size)
                    VStack(alignment: .leading) {
                        PrimaryTextView(song.representativeItem?.title)
                        SecondaryTextView(song.representativeItem?.artist)
                    }
                }
            }
            Spacer()
        }
    }
}
