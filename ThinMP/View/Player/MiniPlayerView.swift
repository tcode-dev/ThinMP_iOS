//
//  MiniPlayerView.swift
//  ThinMP
//
//  Created by tk on 2020/01/26.
//

import SwiftUI


struct MiniPlayerView: View {
    @EnvironmentObject var musicState: MusicState
    
    var size: CGFloat = 40
    
    var body: some View {
        Group {
            if (musicState.isActive) {
                HStack {
                    SquareImageView(artwork: musicState.song!.representativeItem?.artwork, size: size)
                    PrimaryTextView(musicState.song!.representativeItem?.title)
                    Spacer()
                }
                .frame(height: 50)
                .padding(.leading, 10)
                .background(Color.white)
            } else {
                EmptyView()
            }
        }
    }
}
