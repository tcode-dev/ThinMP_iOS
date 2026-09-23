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

    /// primaryText は詳細ページが読み込んだ名前。すぐ入力欄に出せるように受け取るが、
    /// 詳細ページ自身がまだ読み込めていないと nil で渡ってくるので、そのときは読み込んだ名前で埋める
    init(playlistId: PlaylistId, primaryText: String?) {
        self.playlistId = playlistId
        _name = State(initialValue: primaryText ?? "")
    }

    var body: some View {
        EditPageLayout(isDoneEnabled: vm.playlist != nil && !trimmedName.isEmpty, onNavBarTap: { isNameFocused = false }, onDone: { vm.save(playlistId: playlistId, name: trimmedName) }) {
            VStack(alignment: .leading) {
                TextField("", text: $name)
                    .focused($isNameFocused)
                    .textInputAutocapitalization(.never)
                    .textFieldStyle(.roundedBorder)
                    .padding()
                ZStack {
                    List {
                        if let playlist = Binding($vm.playlist) {
                            ReorderableListView(items: playlist.songs) { song in
                                MediaRowView(media: song)
                            }
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

            if name.isEmpty {
                name = vm.playlist?.primaryText ?? ""
            }
        }
    }

    /// 前後の空白を除いた名前。空白だけの名前では保存しない
    private var trimmedName: String {
        return name.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
