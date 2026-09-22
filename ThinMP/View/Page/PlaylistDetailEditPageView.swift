//
//  PlaylistDetailEditPageView.swift
//  ThinMP
//
//  Created by tk on 2021/05/04.
//

import SwiftUI

struct PlaylistDetailEditPageView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var vm = PlaylistDetailViewModel()
    @State private var name = ""
    @State private var editing = false

    let playlistId: PlaylistId
    let primaryText: String?

    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                EditNavBarView(top: geometry.safeAreaInsets.top, onCancel: { dismiss() }) {
                    update()
                    dismiss()
                }
                .modifier(EditModifier(editing: editing))
                VStack(alignment: .leading) {
                    TextField("", text: $name, onEditingChanged: { begin in
                        editing = begin
                    })
                        .textInputAutocapitalization(.never)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                        .onAppear {
                            name = primaryText ?? ""
                        }
                    ZStack {
                        List {
                            ForEach(vm.songs) { song in
                                MediaRowView(media: song)
                            }
                            .onMove(perform: move)
                            .onDelete(perform: delete)
                            .listRowInsets(.init())
                        }
                        if editing {
                            Rectangle().fill(Color.white.opacity(0.5))
                                .onTapGesture { UIApplication.shared.endEditing() }
                        }
                    }
                }
            }
            .toolbar(.hidden, for: .navigationBar)
            .navigationTitle("")
            .ignoresSafeArea(.container)
            .environment(\.editMode, .constant(.active))
            .task {
                await vm.load(playlistId: playlistId).value
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
        let playlistRegister = PlaylistRegister()

        playlistRegister.update(playlistId: playlistId, name: name, songIds: vm.songs.map { $0.songId })
    }
}
