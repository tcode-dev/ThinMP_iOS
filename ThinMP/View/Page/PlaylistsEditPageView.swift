//
//  PlaylistsEditPageView.swift
//  ThinMP
//
//  Created by tk on 2021/04/24.
//

import SwiftUI

struct PlaylistsEditPageView: View {
    @Environment(\.editMode) var editMode
    @Environment(\.presentationMode) var presentation
    @ObservedObject public var playlists: PlaylistViewModel
    var body: some View {
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

        ZStack(alignment: .top) {
            List() {
                ForEach (playlists.list, id: \.id) { playlist in
                    PlaylistRowView(title: playlist.name)
                }
                .onMove(perform: move)
                .onDelete(perform: delete)
            }
            .padding(.init(top: 50, leading: 0, bottom: 0, trailing: 0))
            .frame(alignment: .top)
        }
        .navigationBarHidden(true)
        .navigationBarTitle(Text(""))
    }

    func move(source: IndexSet, destination: Int) {
        playlists.list.move(fromOffsets: source, toOffset: destination)
    }

    func delete(offsets: IndexSet) {
        playlists.list.remove(atOffsets: offsets)
    }

    func update() {
        let playlistRegister = PlaylistRegister()

        playlistRegister.update(ids: playlists.list.map{$0.id})
    }

    func back() {
        presentation.wrappedValue.dismiss()
    }
}

