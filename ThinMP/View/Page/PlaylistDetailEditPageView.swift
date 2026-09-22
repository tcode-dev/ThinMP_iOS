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
    @State private var name: String
    @FocusState private var isNameFocused: Bool

    let playlistId: PlaylistId

    init(playlistId: PlaylistId, primaryText: String?) {
        self.playlistId = playlistId
        _name = State(initialValue: primaryText ?? "")
    }

    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                EditNavBarView(top: geometry.safeAreaInsets.top, isDoneEnabled: !name.isEmpty, onCancel: { dismiss() }) {
                    update()
                    dismiss()
                }
                // ボタン以外の場所をタップしたらキーボードを閉じる(ボタンのタップは子が先に受ける)
                .onTapGesture { isNameFocused = false }
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
            .modifier(PageModifier())
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
