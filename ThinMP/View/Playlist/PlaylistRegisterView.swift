//
//  PlaylistRegisterView.swift
//  ThinMP
//
//  Created by tk on 2021/04/01.
//

import SwiftUI

struct PlaylistRegisterView: View {
    @StateObject private var vm = PlaylistRegisterViewModel()
    @State private var isCreate: Bool = false
    @State private var name: String = ""

    let songId: SongId
    let height: CGFloat
    /// キャンセル、または登録が終わったときに呼ばれる(ポップアップを閉じる)
    let onClose: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            if isListShown {
                VStack(spacing: 0) {
                    HStack {
                        Spacer()
                        Button(action: {
                            isCreate.toggle()
                        }) {
                            Text(LocalizedStringKey(LabelConstant.newPlaylist))
                        }
                        Spacer()
                        Button(action: {
                            onClose()
                        }) {
                            Text(LocalizedStringKey(LabelConstant.cancel))
                        }
                        Spacer()
                    }
                    .frame(height: StyleConstant.Height.header)
                    ScrollView {
                        LazyVStack(spacing: 0) {
                            ForEach(vm.playlists) { playlist in
                                PlaylistAddRowView(isRegistered: vm.isRegistered(playlistId: playlist.playlistId), action: {
                                    vm.add(playlistId: playlist.playlistId, songId: songId)
                                    onClose()
                                }) {
                                    MediaRowView(media: playlist)
                                }
                                .frame(height: StyleConstant.Height.row)
                                Divider()
                                    .frame(height: StyleConstant.dividerHeight)
                            }
                        }
                    }
                }
                .padding(.bottom, StyleConstant.Padding.small)
                .frame(height: contentHeight)
            } else {
                VStack(spacing: 0) {
                    Text(LocalizedStringKey(LabelConstant.playlistName))
                        .frame(height: StyleConstant.Height.row)
                    TextField("", text: $name)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    HStack {
                        Spacer()
                        Button(action: {
                            vm.create(songId: songId, name: trimmedName)
                            onClose()
                        }) {
                            Text(LocalizedStringKey(LabelConstant.done))
                        }
                        .disabled(trimmedName.isEmpty)
                        Spacer()
                        Button(action: {
                            if hasNoPlaylists {
                                onClose()
                            } else {
                                isCreate.toggle()
                            }
                        }) {
                            Text(LocalizedStringKey(LabelConstant.cancel))
                        }
                        Spacer()
                    }
                    .frame(height: StyleConstant.Height.row)
                }
                .padding(.horizontal, StyleConstant.Padding.small)
            }
        }
        .padding(.horizontal, StyleConstant.Padding.small)
        .background(Color(UIColor.systemGray5))
        .cornerRadius(StyleConstant.cornerRadius)
        .padding(.horizontal, StyleConstant.Padding.large)
        .task {
            await vm.load(songId: songId).value
        }
    }

    /// 前後の空白を除いた名前。空白だけの名前では作らない
    private var trimmedName: String {
        return name.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    /// 読み込みが終わってプレイリストが 1 つも無いと分かったときだけ、最初から作成フォームを出す
    /// 読み込み中に作成フォームを出すと、読み終わった瞬間に一覧へ切り替わって入力中の名前が消える
    private var hasNoPlaylists: Bool {
        return vm.isLoaded && vm.playlists.isEmpty
    }

    private var isListShown: Bool {
        return !isCreate && !hasNoPlaylists
    }

    /// 一覧がポップアップに収まらないときは、上下に Padding.large の余白を残した画面の高さまでにする
    private var contentHeight: CGFloat {
        let panelHeight = StyleConstant.Height.header + (CGFloat(vm.playlists.count) * (StyleConstant.Height.row + StyleConstant.dividerHeight)) + StyleConstant.Padding.small

        return min(panelHeight, height - (StyleConstant.Padding.large * 2))
    }
}
