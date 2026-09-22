//
//  FavoriteSongsEditPageView.swift
//  ThinMP
//
//  Created by tk on 2021/02/28.
//

import SwiftUI

struct FavoriteSongsEditPageView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var vm = FavoriteSongsViewModel()

    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                EditNavBarView(top: geometry.safeAreaInsets.top, onCancel: { dismiss() }) {
                    update()
                    dismiss()
                }
                List {
                    ForEach(vm.songs) { song in
                        MediaRowView(media: song)
                    }
                    .onMove(perform: move)
                    .onDelete(perform: delete)
                    .listRowInsets(.init())
                }
            }
            .modifier(PageModifier())
            .environment(\.editMode, .constant(.active))
            .task {
                await vm.load().value
            }
        }
    }

    private func move(source: IndexSet, destination: Int) {
        vm.songs.move(fromOffsets: source, toOffset: destination)
    }

    private func delete(offsets: IndexSet) {
        vm.songs.remove(atOffsets: offsets)
    }

    private func update() {
        let favoriteSongRegister = FavoriteSongRegister()

        favoriteSongRegister.update(songIds: vm.songs.map { $0.songId })
    }
}
