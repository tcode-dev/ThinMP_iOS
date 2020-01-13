//
//  ArtistSongsView.swift
//  ThinMP
//
//  Created by tk on 2020/01/14.
//

import SwiftUI

struct ArtistSongsView: View {
    var list: [Song]
    var body: some View {
        VStack(alignment: .leading) {
            ForEach(list) { song in
                SongRowView(song: song)
            }
        }
    }
}
