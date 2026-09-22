//
//  FavoriteArtistsEditPageView.swift
//  ThinMP
//
//  Created by tk on 2021/01/10.
//

import SwiftUI

struct FavoriteArtistsEditPageView: View {
    @StateObject private var vm = FavoriteArtistsViewModel()

    var body: some View {
        EditPageLayout(isDoneEnabled: vm.isLoaded, onDone: vm.save) {
            List {
                ForEach(vm.artists) { artist in
                    PlainRowView(media: artist)
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
        vm.artists.move(fromOffsets: source, toOffset: destination)
    }

    private func delete(offsets: IndexSet) {
        vm.artists.remove(atOffsets: offsets)
    }
}
