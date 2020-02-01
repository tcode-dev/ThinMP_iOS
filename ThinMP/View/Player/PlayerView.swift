//
//  PlayerView.swift
//  ThinMP
//
//  Created by tk on 2020/02/01.
//

import SwiftUI

struct PlayerView: View {
    @EnvironmentObject var musicPlayer: MusicPlayer

    var body: some View {
        ZStack(alignment: .top) {
            VStack {
                PrimaryTextView(self.musicPlayer.song?.representativeItem?.title)
            }
        }
    }
}
