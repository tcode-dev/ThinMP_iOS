//
//  FavoriteSongsEditPageView.swift
//  ThinMP
//
//  Created by tk on 2021/02/28.
//

import SwiftUI

struct FavoriteSongsEditPageView: View {
    private var DONE_TEXT: String = "Done"
    private var CANCEL_TEXT: String = "Cancel"

    @Environment(\.editMode) var editMode
    @Environment(\.presentationMode) var presentation
    @ObservedObject var songs = FavoriteSongsViewModel()

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
                ForEach (self.songs.list, id: \.persistentID) { song in
                    SongRowView(song: song)
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
            songs.load()
        }
    }

    func move(source: IndexSet, destination: Int) {
        self.songs.list.move(fromOffsets: source, toOffset: destination)
    }

    func delete(offsets: IndexSet) {
        self.songs.list.remove(atOffsets: offsets)
    }

    func update() {
        let favoriteSongRegister = FavoriteSongRegister()

        favoriteSongRegister.update(persistentIdList: self.songs.list.map{$0.persistentID})
    }

    func back() {
        self.presentation.wrappedValue.dismiss()
    }
}

