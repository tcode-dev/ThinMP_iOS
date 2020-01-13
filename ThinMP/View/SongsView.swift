//
//  SongsView.swift
//  ThinMP
//
//  Created by tk on 2020/01/13.
//

import SwiftUI

struct SongsView: View {
    var list: [Song]
    var body: some View {
        List(list){ song in
            SongRowView(song: song)
        }
    }
}
