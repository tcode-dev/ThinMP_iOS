//
//  PlaylistRegisterView.swift
//  ThinMP
//
//  Created by tk on 2021/04/01.
//

import MediaPlayer
import SwiftUI

struct PlaylistRegisterView: View {
    @StateObject var vm = PlaylistsViewModel()
    @State private var isCreate: Bool = false
    @State private var name: String = ""

    let songId: SongId
    let height: CGFloat
    @Binding var showingPopup: Bool

    var body: some View {
        VStack(spacing: 0) {
            if vm.playlists.count != 0 && !isCreate {
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
                            showingPopup.toggle()
                        }) {
                            Text(LocalizedStringKey(LabelConstant.cancel))
                        }
                        Spacer()
                    }
                    .frame(height: StyleConstant.Height.header)
                    ScrollView {
                        LazyVStack(spacing: 0) {
                            ForEach(vm.playlists) { playlist in
                                PlaylistAddRowView(playlistId: playlist.playlistId, songId: songId, showingPopup: $showingPopup) {
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
                .frame(height: getHeight())
            } else {
                VStack(spacing: 0) {
                    Text(LocalizedStringKey(LabelConstant.playlistName))
                        .frame(height: StyleConstant.Height.row)
                    TextField("", text: $name)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    HStack {
                        Spacer()
                        Button(action: {
                            let playlistRegister = PlaylistRegister()

                            playlistRegister.create(songId: songId, name: name)
                            showingPopup.toggle()
                        }) {
                            Text(LocalizedStringKey(LabelConstant.done))
                        }
                        Spacer()
                        Button(action: {
                            if vm.playlists.count > 0 {
                                isCreate.toggle()
                            } else {
                                showingPopup.toggle()
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
        .frame(width: .infinity)
        .padding(.horizontal, StyleConstant.Padding.small)
        .background(Color(UIColor.systemGray5))
        .cornerRadius(StyleConstant.cornerRadius)
        .padding(.horizontal, StyleConstant.Padding.large)
        .onAppear {
            vm.load()
        }
    }

    private func getHeight() -> CGFloat? {
        let panelHeight = StyleConstant.Height.header + (CGFloat(vm.playlists.count) * (StyleConstant.Height.row + StyleConstant.dividerHeight)) + StyleConstant.Padding.small

        if panelHeight > height {
            return height - (StyleConstant.Padding.large * 2)
        } else {
            return panelHeight
        }
    }
}
