//
//  PlaylistsEditPageView.swift
//  ThinMP
//
//  Created by tk on 2021/04/24.
//

import SwiftUI

struct PlaylistsEditPageView: View {
    @Environment(\.presentationMode) var presentation
    @StateObject private var vm = PlaylistsViewModel()

    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                EditNavBarView(top: geometry.safeAreaInsets.top) {
                    HStack {
                        Button(action: {
                            presentation.wrappedValue.dismiss()
                        }) {
                            Text(LocalizedStringKey(LabelConstant.cancel))
                        }
                        Spacer()
                        Button(action: {
                            update()
                            presentation.wrappedValue.dismiss()
                        }) {
                            Text(LocalizedStringKey(LabelConstant.done))
                        }
                    }
                    .padding(.horizontal, StyleConstant.Padding.large)
                }
                VStack(alignment: .leading) {
                    List {
                        ForEach(vm.playlists) { playlist in
                            MediaRowView(media: playlist)
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
