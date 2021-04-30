//
//  FavoriteSongsEditPageView.swift
//  ThinMP
//
//  Created by tk on 2021/02/28.
//

import SwiftUI

struct FavoriteSongsEditPageView: View {
    @Environment(\.editMode) var editMode
    @Environment(\.presentationMode) var presentation

    @ObservedObject public var songs: FavoriteSongsViewModel
    
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                EditNavBarView(top: geometry.safeAreaInsets.top) {
                    HStack {
                        Button(action: {
                            back()
                        }) {
                            Text("Cancel")
                        }
                        Spacer()
                        Button(action: {
                            update()
                            back()
                        }) {
                            Text("Done")
                        }
                    }
                    .padding(.horizontal, 20)
                }
                VStack(alignment: .leading) {
                    List {
                        ForEach (self.songs.list, id: \.persistentID) { song in
                            SongRowView(song: song)
                        }
                        .onMove(perform: move)
                        .onDelete(perform: delete)
                    }
                }
            }
            .edgesIgnoringSafeArea(.all)
            .navigationBarHidden(true)
            .navigationBarTitle(Text(""))
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
