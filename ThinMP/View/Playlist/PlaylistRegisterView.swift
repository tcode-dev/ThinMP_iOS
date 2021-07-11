//
//  PlaylistRegisterView.swift
//  ThinMP
//
//  Created by tk on 2021/04/01.
//

import SwiftUI
import MediaPlayer

struct PlaylistRegisterView: View {
    @StateObject var vm = PlaylistsViewModel()
    @State private var isCreate: Bool = false
    @State private var name: String = ""

    let songId: SongId
    let height: CGFloat
    @Binding var showingPopup: Bool

    var body: some View {
        VStack(spacing: 0) {
            if (vm.playlists.count != 0 && !isCreate) {
                VStack(spacing: 0) {
                    HStack() {
                        Spacer()
                        Button(action: {
                            isCreate.toggle()
                        }) {
                            Text("NewPlaylist")
                        }
                        Spacer()
                        Button(action: {
                            showingPopup.toggle()
                        }) {
                            Text("Cancel")
                        }
                        Spacer()
                    }
                    .frame(height: StyleConstant.height.header)
                    ScrollView() {
                        LazyVStack(spacing: 0) {
                            ForEach(vm.playlists) { playlist in
                                PlaylistAddRowView(playlistId: playlist.playlistId, songId: songId, showingPopup: $showingPopup) {
                                    MediaRowView(media: playlist)
                                }
                                .frame(height: StyleConstant.height.row)
                                Divider().frame(height: StyleConstant.height.divider)
                            }
                        }
                    }
                }
                .padding(.bottom, StyleConstant.padding.medium)
                .frame(height: getHeight())
            } else {
                VStack(spacing: 0) {
                    Text("PlaylistName")
                        .frame(height: StyleConstant.height.row)
                    TextField("", text: $name)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    HStack {
                        Spacer()
                        Button(action: {
                            let playlistRegister = PlaylistRegister()

                            playlistRegister.create(songId: songId, name: name)
                            showingPopup.toggle()
                        }) {
                            Text("Done")
                        }
                        Spacer()
                        Button(action: {
                            if (vm.playlists.count > 0) {
                                isCreate.toggle()
                            } else {
                                showingPopup.toggle()
                            }
                        }) {
                            Text("Cancel")
                        }
                        Spacer()
                    }
                    .frame(height: StyleConstant.height.row)
                }
                .padding(.horizontal, StyleConstant.padding.medium)
            }
        }
        .frame(width: .infinity)
        .padding(.horizontal, StyleConstant.padding.medium)
        .background(Color(UIColor.systemGray5))
        .cornerRadius(4)
        .padding(.horizontal, StyleConstant.padding.large)
        .onAppear() {
            vm.load()
        }
    }

    private func getHeight() -> CGFloat? {
        let panelHeight = StyleConstant.height.header + (CGFloat(vm.playlists.count) * (StyleConstant.height.row + StyleConstant.height.divider)) + StyleConstant.padding.medium

        if (panelHeight > height) {
            return height - (StyleConstant.padding.large * 2)
        } else {
            return panelHeight
        }
    }
}
