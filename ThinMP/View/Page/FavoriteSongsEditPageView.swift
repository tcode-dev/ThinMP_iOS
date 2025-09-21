//
//  FavoriteSongsEditPageView.swift
//  ThinMP
//
//  Created by tk on 2021/02/28.
//

import SwiftUI

struct FavoriteSongsEditPageView: View {
    @Environment(\.presentationMode) var presentation
    @StateObject private var vm = FavoriteSongsViewModel()

    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                EditNavBarView(top: geometry.safeAreaInsets.top) {
                    HStack {
                        Button(action: {
                            back()
                        }) {
                            Text(LocalizedStringKey(LabelConstant.cancel))
                        }
                        Spacer()
                        Button(action: {
                            update()
                            back()
                        }) {
                            Text(LocalizedStringKey(LabelConstant.done))
                        }
                    }
                    .padding(.horizontal, StyleConstant.Padding.large)
                }
                VStack(alignment: .leading) {
                    List {
                        ForEach(vm.songs) { song in
                            MediaRowView(media: song)
                        }
                        .onMove(perform: move)
                        .onDelete(perform: delete)
                        .listRowInsets(.init())
                    }
                }
            }
            .navigationBarHidden(true)
            .navigationBarTitle(Text(""))
            .edgesIgnoringSafeArea(.all)
            .environment(\.editMode, .constant(.active))
            .onAppear {
                vm.load()
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

    private func back() {
        presentation.wrappedValue.dismiss()
    }
}
