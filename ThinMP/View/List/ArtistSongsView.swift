//
//  ArtistSongsView.swift
//  ThinMP
//
//  Created by tk on 2020/01/14.
//

import SwiftUI

struct ArtistSongListView: View {
    var list: [Song]
    var body: some View {
        VStack(alignment: .leading) {
            ForEach(list) { song in
                ArtistSongRowView(song: song).padding(0)
                Divider()
            }
        }
    }
}
