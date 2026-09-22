//
//  PlaylistDetailEditPageView.swift
//  ThinMP
//
//  Created by tk on 2021/05/04.
//

import SwiftUI

struct PlaylistDetailEditPageView: View {
    @StateObject private var vm = PlaylistDetailViewModel()
    @State private var name: String
    @FocusState private var isNameFocused: Bool

    let playlistId: PlaylistId

    init(playlistId: PlaylistId, primaryText: String?) {
        self.playlistId = playlistId
        _name = State(initialValue: primaryText ?? "")
    }

    var body: some View {
        EditPageLayout(isDoneEnabled: !name.isEmpty, onNavBarTap: { isNameFocused = false }, onDone: update) {
            VStack(alignment: .leading) {
                TextField("", text: $name)
                    .focused($isNameFocused)
                    .textInputAutocapitalization(.never)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                ZStack {
                    List {
                        ForEach(vm.songs) { song in
                            MediaRowView(media: song)
                        }
                        .onMove(perform: move)
                        .onDelete(perform: delete)
                        .listRowInsets(.init())
                    }
                    // 入力中は一覧を薄くして、タップでキーボードを閉じる
                    if isNameFocused {
                        Rectangle().fill(Color(UIColor.systemBackground).opacity(0.5))
                            .onTapGesture { isNameFocused = false }
                    }
                }
            }
        }
        .task {
            await vm.load(playlistId: playlistId).value
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
