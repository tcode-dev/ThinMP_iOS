//
//  PlaylistRegisterView.swift
//  ThinMP
//
//  Created by tk on 2021/04/01.
//

import SwiftUI
import MediaPlayer

struct PlaylistRegisterView: View {
    private let headerHeight: CGFloat = 60
    private let rowHeight: CGFloat = 50
    private let dividerHeight: CGFloat = 0.5

    @StateObject var vm = PlaylistsViewModel()
    @State private var isCreate: Bool = false
    @State private var name: String = ""

    let songId: SongId
    let height: CGFloat
    @Binding var showingPopup: Bool

    func getHeight() -> CGFloat? {
        let panelHeight = headerHeight + (CGFloat(vm.playlists.count) * (rowHeight + dividerHeight)) + StyleConstant.padding.medium

        if (panelHeight > height) {
            return height - (StyleConstant.padding.large * 2)
        } else {
            return panelHeight
        }
    }

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
                    .frame(height: headerHeight)
                    ScrollView() {
                        LazyVStack(spacing: 0) {
                            ForEach(vm.playlists) { playlist in
                                PlaylistAddRowView(playlistId: playlist.playlistId, songId: songId, showingPopup: $showingPopup) {
                                    MediaRowView(media: playlist)
                                }
                                .frame(height: rowHeight)
                                Divider().frame(height: dividerHeight)
                            }
                        }
                    }
                }
                .padding(.bottom, StyleConstant.padding.medium)
                .frame(height: getHeight())
            } else {
                VStack(spacing: 0) {
                    Text("PlaylistName")
                        .frame(height: rowHeight)
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
                    .frame(height: rowHeight)
                }
                .padding(.horizontal, StyleConstant.padding.medium)
            }
        }
        .frame(width: .infinity)
        .padding(.horizontal, StyleConstant.padding.medium)
        .background(Color.white)
        .cornerRadius(4)
        .padding(.horizontal, StyleConstant.padding.large)
        .onAppear() {
            vm.load()
        }
    }
}
