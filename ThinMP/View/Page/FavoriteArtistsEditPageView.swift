//
//  FavoriteArtistsEditPageView.swift
//  ThinMP
//
//  Created by tk on 2021/01/10.
//

import SwiftUI

struct FavoriteArtistsEditPageView: View {
    @Environment(\.editMode) var editMode
    @Environment(\.presentationMode) var presentation

    @ObservedObject public var artists: FavoriteArtistsViewModel

    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                EditNavBarView(top: geometry.safeAreaInsets.top) {
                    HStack {
                        Button(action: {
                            presentation.wrappedValue.dismiss()
                        }) {
                            Text("Cancel")
                        }
                        Spacer()
                        Button(action: {
                            update()
                            presentation.wrappedValue.dismiss()
                        }) {
                            Text("Done")
                        }
                    }
                    .padding(.horizontal, 20)
                }
                VStack(alignment: .leading) {
                    List {
                        ForEach (self.artists.list) { artist in
                            ArtistRowView(artist: artist)
                        }
                        .onMove(perform: move)
                        .onDelete(perform: delete)
                    }
                }
            }

            .navigationBarHidden(true)
            .navigationBarTitle(Text(""))
        }
    }

    func move(source: IndexSet, destination: Int) {
        self.artists.list.move(fromOffsets: source, toOffset: destination)
    }

    func delete(offsets: IndexSet) {
        self.artists.list.remove(atOffsets: offsets)
    }

    func update() {
        let favoriteArtistRegister = FavoriteArtistRegister()

        favoriteArtistRegister.update(persistentIdList: self.artists.list.map{$0.persistentId})
    }
}
