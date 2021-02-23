//
//  AlbumSongRowView.swift
//  ThinMP
//
//  Created by tk on 2020/01/20.
//

import SwiftUI
import MediaPlayer

struct AlbumSongRowView: View {
    @EnvironmentObject var musicPlayer: MusicPlayer

    let list: [MPMediaItemCollection]
    let index: Int
    let song: MPMediaItemCollection
    
    init(list: [MPMediaItemCollection], index: Int) {
        self.list = list
        self.index = index
        self.song = list[index]
    }
    
    var body: some View {
        Button(action: {
            self.musicPlayer.start(list: self.list, currentIndex: self.index)
        }) {
            HStack {
                PrimaryTextView(song.representativeItem?.title)
                Spacer()
            }.padding(.top, 5)
        }
    }
}
