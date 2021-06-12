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

    @ObservedObject public var vm: PlaylistsViewModel

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
                        ForEach (vm.playlists, id: \.id) { playlist in
                            MediaRowView(media: playlist)
                        }
                        .onMove(perform: move)
                        .onDelete(perform: delete)
                    }
                }
            }
            .navigationBarHidden(true)
            .navigationBarTitle(Text(""))
            .edgesIgnoringSafeArea(.all)
        }
    }

    func move(source: IndexSet, destination: Int) {
        vm.playlists.move(fromOffsets: source, toOffset: destination)
    }

    func delete(offsets: IndexSet) {
        vm.playlists.remove(atOffsets: offsets)
    }

    func update() {
        let playlistRegister = PlaylistRegister()

        playlistRegister.update(playlistIds: vm.playlists.map{$0.id})
    }
}
