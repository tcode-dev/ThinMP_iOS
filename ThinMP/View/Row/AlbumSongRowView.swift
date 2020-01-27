//
//  AlbumSongRowView.swift
//  ThinMP
//
//  Created by tk on 2020/01/20.
//

import SwiftUI
import MediaPlayer

struct AlbumSongRowView: View {
    @EnvironmentObject var musicState: MusicState
    var song: MPMediaItemCollection
    var body: some View {
        Button(action: {
            let musicService = MusicService.sharedInstance()
            self.musicState.start(song: self.song)
            musicService.start(itemCollection: self.song)
        }) {
            HStack {
                PrimaryTextView(song.representativeItem?.title)
                Spacer()
            }.padding(.top, 5)
        }
    }
}
