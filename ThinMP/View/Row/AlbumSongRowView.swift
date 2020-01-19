//
//  AlbumSongRowView.swift
//  ThinMP
//
//  Created by tk on 2020/01/20.
//

import SwiftUI

struct AlbumSongRowView: View {
    var song: Song
    var body: some View {
        HStack {
            PrimaryTextView(song.title)
            Spacer()
        }.padding(.top, 5)
    }
}
