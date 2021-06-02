//
//  PlaylistRegisterView.swift
//  ThinMP
//
//  Created by tk on 2021/04/01.
//

import SwiftUI
import MediaPlayer

struct PlaylistRegisterView: View {
    private let CREATE_TEXT: String = "プレイリストを作成"
    private let INPUT_TEXT: String = "プレイリスト名を入力"
    private let OK_TEXT: String = "OK"
    private let CANCEL_TEXT: String = "CANCEL"
    private let rowHeight: CGFloat = 44

    @StateObject var vm = PlaylistViewModel()
    @State private var isCreate: Bool = false
    @State private var name: String = ""

    let persistentId: MPMediaEntityPersistentID
    @Binding var showingPopup: Bool
    let height: CGFloat

    func getHeight() -> CGFloat? {
        if (isCreate) {
            return nil
        }

        let panelHeight = CGFloat(vm.list.count) * rowHeight + 70
        if (panelHeight > height) {
            return height - 40
        } else {
            return panelHeight
        }
    }

    var body: some View {
        VStack {
            if (!isCreate) {
                VStack {
                    HStack {
                        Spacer()
                        Button(action: {
                            isCreate.toggle()
                        }) {
                            Text(CREATE_TEXT)
                        }
                        Spacer()
                        Button(action: {
                            showingPopup.toggle()
                        }) {
                            Text(CANCEL_TEXT)
                        }
                        Spacer()
                    }
                    .frame(height: 50)
                    ScrollView(.vertical) {
                        LazyVStack {
                            ForEach(vm.list) { playlist in
                                PlaylistAddRowView(playlistId: playlist.id, persistentId: persistentId, showingPopup: $showingPopup) {
                                    MediaRowView(media: playlist)
                                }
                                Divider()
                                    .frame(height: 1)
                            }
                        }
                    }
                }
            } else {
                VStack {
                    Text(INPUT_TEXT)
                    TextField("", text: $name)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                    HStack {
                        Spacer()
                        Button(action: {
                            let playlistRegister = PlaylistRegister()

                            playlistRegister.create(persistentId: persistentId, name: name)
                            showingPopup.toggle()
                        }) {
                            Text(OK_TEXT)
                        }
                        Spacer()
                        Button(action: {
                            isCreate.toggle()
                        }) {
                            Text(CANCEL_TEXT)
                        }
                        Spacer()
                    }
                }
            }
        }
        .frame(width: .infinity, height: getHeight())
        .padding(10)
        .background(Color.white)
        .cornerRadius(4)
        .padding(20)
        .onAppear() {
            vm.load()
        }
    }
}
