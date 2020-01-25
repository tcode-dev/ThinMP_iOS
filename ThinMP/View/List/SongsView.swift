//
//  SongsView.swift
//  ThinMP
//
//  Created by tk on 2020/01/13.
//

import SwiftUI
import MediaPlayer

struct SongsView: View {
    var list: [MPMediaItemCollection]
    var body: some View {
        ForEach(list.indices) { index in
            SongRowView(song: self.list[index])
        }
    }
}
