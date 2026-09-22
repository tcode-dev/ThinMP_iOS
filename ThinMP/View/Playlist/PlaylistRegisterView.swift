//
//  PlaylistRegisterView.swift
//  ThinMP
//
//  Created by tk on 2021/04/01.
//

import SwiftUI

struct PlaylistRegisterView: View {
    @StateObject private var vm = PlaylistsViewModel()
    @State private var isCreate: Bool = false
    @State private var name: String = ""

    let songId: SongId
    let height: CGFloat
    /// キャンセル、または登録が終わったときにポップアップを閉じる
    let dismiss: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            if !vm.playlists.isEmpty, !isCreate {
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
                            dismiss()
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
                                    dismiss()
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
                            vm.create(songId: songId, name: name)
                            dismiss()
                        }) {
                            Text(LocalizedStringKey(LabelConstant.done))
                        }
                        .disabled(name.isEmpty)
                        Spacer()
                        Button(action: {
                            if !vm.playlists.isEmpty {
                                isCreate.toggle()
                            } else {
                                dismiss()
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

    /// 一覧がポップアップに収まらないときは画面の高さいっぱいまでにする
    private var contentHeight: CGFloat {
        let panelHeight = StyleConstant.Height.header + (CGFloat(vm.playlists.count) * (StyleConstant.Height.row + StyleConstant.dividerHeight)) + StyleConstant.Padding.small

        if panelHeight > height {
            return height - (StyleConstant.Padding.large * 2)
        } else {
            return panelHeight
        }
    }
}
