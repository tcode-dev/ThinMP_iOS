//
//  FavoriteSongsEditPageView.swift
//  ThinMP
//
//  Created by tk on 2021/02/28.
//

import SwiftUI

struct FavoriteSongsEditPageView: View {
    @StateObject private var vm = FavoriteSongsViewModel()

    var body: some View {
        EditPageLayout(isDoneEnabled: vm.isLoaded, onDone: vm.save) {
            List {
                ForEach(vm.songs) { song in
                    MediaRowView(media: song)
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
        vm.songs.move(fromOffsets: source, toOffset: destination)
    }

    private func delete(offsets: IndexSet) {
        vm.songs.remove(atOffsets: offsets)
    }
}
