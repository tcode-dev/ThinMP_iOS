//
//  AlbumSongRowView.swift
//  ThinMP
//
//  Created by tk on 2020/01/20.
//

import SwiftUI
import MediaPlayer

struct AlbumSongRowView: View {
    let song: MPMediaItemCollection
    
    var body: some View {
        HStack {
            PrimaryTextView(song.representativeItem?.title)
            Spacer()
        }
    }
}
