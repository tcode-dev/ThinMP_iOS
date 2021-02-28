//
//  PlayRowView.swift
//  ThinMP
//
//  Created by tk on 2021/02/28.
//

import SwiftUI
import MediaPlayer

struct PlayRowView<Content> : View where Content: View {
    @EnvironmentObject var musicPlayer: MusicPlayer

    let list: [MPMediaItemCollection]
    let index: Int
    let content: () -> Content

    init(list: [MPMediaItemCollection], index: Int, @ViewBuilder content: @escaping () -> Content) {
        self.list = list
        self.index = index
        self.content = content
    }

    var body: some View {

        Button(action: {
            self.musicPlayer.start(list: self.list, currentIndex: self.index)
        }) {
            content()
        }
    }
}
