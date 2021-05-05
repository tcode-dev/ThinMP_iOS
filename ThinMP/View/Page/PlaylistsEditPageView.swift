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
                        ForEach (playlists.list, id: \.id) { playlist in
                            PlaylistRowView(title: playlist.name)
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
        playlists.list.move(fromOffsets: source, toOffset: destination)
    }

    func delete(offsets: IndexSet) {
        playlists.list.remove(atOffsets: offsets)
    }

    func update() {
        let playlistRegister = PlaylistRegister()

        playlistRegister.update(playlistIds: playlists.list.map{$0.id})
    }
}
