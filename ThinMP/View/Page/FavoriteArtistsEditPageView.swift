//
//  FavoriteArtistsEditPageView.swift
//  ThinMP
//
//  Created by tk on 2021/01/10.
//

import SwiftUI

struct FavoriteArtistsEditPageView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var vm = FavoriteArtistsViewModel()

    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                EditNavBarView(top: geometry.safeAreaInsets.top) {
                    HStack {
                        Button(action: {
                            dismiss()
                        }) {
                            Text(LocalizedStringKey(LabelConstant.cancel))
                        }
                        Spacer()
                        Button(action: {
                            update()
                            dismiss()
                        }) {
                            Text(LocalizedStringKey(LabelConstant.done))
                        }
                    }
                    .padding(.horizontal, StyleConstant.Padding.large)
                }
                VStack(alignment: .leading) {
                    List {
                        ForEach(vm.artists) { artist in
                            PlainRowView(media: artist)
                        }
                        .onMove(perform: move)
                        .onDelete(perform: delete)
                        .listRowInsets(.init())
                    }
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
        vm.artists.move(fromOffsets: source, toOffset: destination)
    }

    private func delete(offsets: IndexSet) {
        vm.artists.remove(atOffsets: offsets)
    }

    private func update() {
        let favoriteArtistRegister = FavoriteArtistRegister()

        favoriteArtistRegister.update(artistIds: vm.artists.map { $0.artistId })
    }
}
