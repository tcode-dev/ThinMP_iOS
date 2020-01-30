//
//  SwiftUIView.swift
//  ThinMP
//
//  Created by tk on 2020/01/13.
//

import SwiftUI
import MediaPlayer

struct SongRowView: View {
    @EnvironmentObject var musicState: MusicState
    var list: [MPMediaItemCollection]
    var index: Int
    var song: MPMediaItemCollection
    var size: CGFloat = 40
    
    init(list: [MPMediaItemCollection], index: Int) {
        self.list = list
        self.index = index
        self.song = list[index]
    }
    
    var body: some View {
        HStack {
            Button(action: {
                let musicService = MusicService.sharedInstance()
                musicService.start(list: self.list, currentIndex: self.index)
                self.musicState.start(song: self.song)
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
