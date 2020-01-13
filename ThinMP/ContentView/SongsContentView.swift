//
//  SongsContentView.swift
//  ThinMP
//
//  Created by tk on 2020/01/13.
//

import SwiftUI

struct SongsContentView: View {
    @ObservedObject var songs = SongsViewModel()
    
    var body: some View {
        List(songs.list){ song in
            SongRowView(song: song)
        }
    }
}
