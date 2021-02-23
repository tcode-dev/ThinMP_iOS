//
//  ArtistSongRowView.swift
//  ThinMP
//
//  Created by tk on 2020/01/20.
//

import SwiftUI
import MediaPlayer

struct ArtistSongRowView: View {
    private let size: CGFloat = 40

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
        HStack {
            SquareImageView(artwork: song.representativeItem?.artwork, size: size)
            PrimaryTextView(song.representativeItem?.title)
            Spacer()
            SongMenuButtonView(persistentId: self.song.representativeItem!.persistentID)
        }
    }
}
