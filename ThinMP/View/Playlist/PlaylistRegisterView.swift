//
//  PlaylistRegisterView.swift
//  ThinMP
//
//  Created by tk on 2021/04/01.
//

import SwiftUI

struct PlaylistRegisterView: View {
    @StateObject private var vm = PlaylistRegisterViewModel()
    /// 新しいプレイリストの作成フォームを出しているか。false なら既存のプレイリストの一覧
    @State private var isCreateFormShown: Bool = false
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
                            isCreateFormShown = true
                        }) {
                            Text(label: LabelConstant.newPlaylist)
                        }
                        Spacer()
                        Button(action: onClose) {
                            Text(label: LabelConstant.cancel)
                        }
                        Spacer()
                    }
                    .frame(height: StyleConstant.Height.header)
                    ScrollView {
                        LazyVStack(spacing: 0) {
                            ForEach(vm.playlists ?? []) { playlist in
                                PlaylistAddRowView(isRegistered: playlist.songIds.contains(songId), action: {
                                    vm.add(playlistId: playlist.playlistId, songId: songId)
                                    onClose()
                                }) {
                                    MediaRowView(media: playlist, showsSecondaryText: false)
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
                    Text(label: LabelConstant.playlistName)
                        .frame(height: StyleConstant.Height.row)
                    TextField("", text: $name)
                        .textFieldStyle(.roundedBorder)
                    HStack {
                        Spacer()
                        Button(action: {
                            vm.create(songId: songId, name: trimmedName)
                            onClose()
                        }) {
                            Text(label: LabelConstant.done)
                        }
                        .disabled(trimmedName.isEmpty)
                        Spacer()
                        Button(action: {
                            if hasNoPlaylists {
                                onClose()
                            } else {
                                isCreateFormShown = false
                            }
                        }) {
                            Text(label: LabelConstant.cancel)
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
        .clipShape(.rect(cornerRadius: StyleConstant.cornerRadius))
        .padding(.horizontal, StyleConstant.Padding.large)
        .onAppear {
            vm.load()
        }
    }

    /// 前後の空白を除いた名前。空白だけの名前では作らない
    private var trimmedName: String {
        return name.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    /// 読み込みが終わってプレイリストが 1 つも無いと分かったときだけ、最初から作成フォームを出す
    /// 読み込み中に作成フォームを出すと、読み終わった瞬間に一覧へ切り替わって入力中の名前が消える
    private var hasNoPlaylists: Bool {
        return vm.playlists?.isEmpty == true
    }

    private var isListShown: Bool {
        return !isCreateFormShown && !hasNoPlaylists
    }

    /// 一覧がポップアップに収まらないときは、上下に Padding.large の余白を残した画面の高さまでにする
    private var contentHeight: CGFloat {
        let panelHeight = StyleConstant.Height.header + (CGFloat(vm.playlists?.count ?? 0) * (StyleConstant.Height.row + StyleConstant.dividerHeight)) + StyleConstant.Padding.small

        return min(panelHeight, height - (StyleConstant.Padding.large * 2))
    }
}
