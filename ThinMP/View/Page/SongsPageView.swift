//
//  SongsPageView.swift
//  ThinMP
//
//  Created by tk on 2020/01/13.
//

import SwiftUI

struct SongsPageView: View {
    @ObservedObject var songs = SongsViewModel()
    
    var body: some View {
        Group {
            List(self.songs.list.indices) { index in
                SongRowView(list: self.songs.list, index:index)
            }
            .navigationBarTitle("Songs")
        }
    }
}
