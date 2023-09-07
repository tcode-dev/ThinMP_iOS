//
//  PlayRowView.swift
//  ThinMP
//
//  Created by tk on 2021/02/28.
//

import SwiftUI

struct PlayRowView<Content>: View where Content: View {
    @EnvironmentObject var musicPlayer: MusicPlayer

    let list: [SongModel]
    let index: Int
    let content: () -> Content

    var body: some View {
        Button(action: {
            musicPlayer.start(list: list, currentIndex: index)
        }) {
            content()
        }
    }
}
