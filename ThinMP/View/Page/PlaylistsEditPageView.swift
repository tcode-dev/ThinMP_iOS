//
//  PlaylistsEditPageView.swift
//  ThinMP
//
//  Created by tk on 2021/04/24.
//

import SwiftUI

struct PlaylistsEditPageView: View {
    @StateObject private var vm = PlaylistsViewModel()

    var body: some View {
        EditPageLayout(isDoneEnabled: vm.isLoaded, onDone: vm.save) {
            List {
                ForEach(vm.playlists) { playlist in
                    MediaRowView(media: playlist)
                }
                .onMove(perform: move)
                .onDelete(perform: delete)
                .listRowInsets(.init())
            }
        }
        .task {
            await vm.load().value
        }
    }

    private func move(source: IndexSet, destination: Int) {
        vm.playlists.move(fromOffsets: source, toOffset: destination)
    }

    private func delete(offsets: IndexSet) {
        vm.playlists.remove(atOffsets: offsets)
    }
}
