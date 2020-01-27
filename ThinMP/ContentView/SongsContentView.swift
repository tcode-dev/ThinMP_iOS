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
        Group {
            List(self.songs.list.indices) { index in
                SongRowView(song: self.songs.list[index])
            }
            .navigationBarTitle("Songs")
        }
    }
}
