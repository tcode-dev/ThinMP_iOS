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
    @Binding var isRegister: Bool

    init(list: [MPMediaItemCollection], index: Int, isRegister: Binding<Bool>) {
        self.list = list
        self.index = index
        self.song = list[index]
        self._isRegister = isRegister
    }

    var body: some View {
        HStack {
            SquareImageView(artwork: song.representativeItem?.artwork, size: size)
            PrimaryTextView(song.representativeItem?.title)
            Spacer()
        }.contextMenu {
            FavoriteSongButtonView(persistentId: self.song.representativeItem!.persistentID)
            PlaylistButtonView(isRegister: self.$isRegister)
        }
    }
}
