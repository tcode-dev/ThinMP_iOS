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
    @ObservedObject var artists = FavoriteArtistsViewModel()
    private var DONE_TEXT: String = "Done"
    private var CANCEL_TEXT: String = "Cancel"

    var body: some View {
        HStack {
            Button(action: {
                back()
            }) {
                Text(CANCEL_TEXT)
            }
            Spacer()
            Button(action: {
                update()
                back()
            }) {
                Text(DONE_TEXT)
            }
        }

        ZStack(alignment: .top) {
            List() {
                ForEach (self.artists.list) { artist in
                    ArtistRowView(artist: artist)
                }
                .onMove(perform: move)
                .onDelete(perform: delete)
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

    func back() {
        self.presentation.wrappedValue.dismiss()
    }
}
