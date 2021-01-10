//
//  FavoriteArtistsEditPageView.swift
//  ThinMP
//
//  Created by tk on 2021/01/10.
//

import SwiftUI

struct FavoriteArtistsEditPageView: View {
    @ObservedObject var artists = FavoriteArtistsViewModel()
    @Environment(\.editMode) var editMode

    var body: some View {
        EditButton()
        ZStack(alignment: .top) {
            List() {
                ForEach (self.artists.list) { artist in
                    ArtistRowView(artist: artist)
                }
                .onMove { source, destination in
                    self.artists.list.move(fromOffsets: source, toOffset: destination)
                }
                .onDelete { offsets in
                    self.artists.list.remove(atOffsets: offsets)
                }
            }
            .padding(.init(top: 50, leading: 0, bottom: 0, trailing: 0))
            .frame(alignment: .top)
        }
        .navigationBarHidden(true)
        .navigationBarTitle(Text(""))
        .onAppear() {
            artists.load()
        }
    }
}
