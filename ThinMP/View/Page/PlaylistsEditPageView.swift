//
//  PlaylistsEditPageView.swift
//  ThinMP
//
//  Created by tk on 2021/04/24.
//

import SwiftUI

struct PlaylistsEditPageView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var vm = PlaylistsViewModel()

    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                EditNavBarView(top: geometry.safeAreaInsets.top, onCancel: { dismiss() }) {
                    update()
                    dismiss()
                }
                List {
                    ForEach(vm.playlists) { playlist in
                        MediaRowView(media: playlist)
                    }
                    .onMove(perform: move)
                    .onDelete(perform: delete)
                    .listRowInsets(.init())
                }
            }
            .toolbar(.hidden, for: .navigationBar)
            .navigationTitle("")
            .ignoresSafeArea(.container)
            .environment(\.editMode, .constant(.active))
            .task {
                await vm.load().value
            }
        }
    }

    private func move(source: IndexSet, destination: Int) {
        vm.playlists.move(fromOffsets: source, toOffset: destination)
    }

    private func delete(offsets: IndexSet) {
        vm.playlists.remove(atOffsets: offsets)
    }

    private func update() {
        let playlistRegister = PlaylistRegister()

        playlistRegister.update(playlistIds: vm.playlists.map { $0.playlistId })
    }
}
