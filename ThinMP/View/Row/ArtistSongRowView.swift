//
//  ArtistSongRowView.swift
//  ThinMP
//
//  Created by tk on 2020/01/20.
//

import SwiftUI

struct ArtistSongRowView: View {
    var song: Song
    var cgSize: CGSize = CGSize(width: 40, height: 40)
    var body: some View {
        HStack {
            Image(uiImage: self.song.artwork?.image(at: cgSize) ?? UIImage())
                .resizable()
                .aspectRatio(1, contentMode: .fit)
                .frame(width: 40)
                .cornerRadius(4)
                .overlay(RoundedRectangle(cornerRadius: 4)
                    .stroke(Color("#f2f2f2"), lineWidth: 1))
            
            PrimaryTextView(song.title)
            
            Spacer()
        }
    }
}
