//
//  SwiftUIView.swift
//  ThinMP
//
//  Created by tk on 2020/01/13.
//

import SwiftUI

struct SongRowView: View {
    var song: Song
    var cgSize: CGSize = CGSize(width: 40, height: 40)
    var body: some View {
        HStack {
            Image(uiImage: self.song.artwork?.image(at: cgSize) ?? UIImage())
                .resizable()
                .aspectRatio(1, contentMode: .fit)
                .frame(width: 40)
                .cornerRadius(4)

            VStack(alignment: .leading) {
                PrimaryTextView(song.title)
                SecondaryTextView(song.artist)
            }
            Spacer()
        }
    }
}
