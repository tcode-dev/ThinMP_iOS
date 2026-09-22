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
        EditPageLayout(isDoneEnabled: vm.isLoaded && !name.isEmpty, onNavBarTap: { isNameFocused = false }, onDone: { vm.save(playlistId: playlistId, name: name) }) {
            VStack(alignment: .leading) {
                TextField("", text: $name)
                    .focused($isNameFocused)
                    .textInputAutocapitalization(.never)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                ZStack {
                    List {
                        ReorderableListView(items: songs) { song in
                            MediaRowView(media: song)
                        }
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

    /// 読み込む前は playlist が nil。並び替えと削除は読み込めたときだけ playlist に書き戻す
    private var songs: Binding<[SongModel]> {
        return Binding(get: { vm.playlist?.songs ?? [] }, set: { vm.playlist?.songs = $0 })
    }
}
