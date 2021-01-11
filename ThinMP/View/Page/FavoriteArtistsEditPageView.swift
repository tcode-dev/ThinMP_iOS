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

    var body: some View {
        Button(action: {
            withAnimation() {
                if editMode?.wrappedValue.isEditing == true {
                    update()
                    back()
                } else {
                    editMode?.wrappedValue = .active
                }
            }
        }) {
            if editMode?.wrappedValue.isEditing == true {
                Text("終了")
            } else {
                Text("編集")
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
