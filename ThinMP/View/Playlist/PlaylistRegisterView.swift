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

    @ObservedObject var playlists = PlaylistViewModel()
    @State private var isCreate: Bool = false
    @State private var name: String = ""

    let persistentId: MPMediaEntityPersistentID
    @Binding var showingPopup: Bool

    var body: some View {
        VStack {
            if (!isCreate) {
                HStack {
                    Button(action: {
                        isCreate.toggle()
                    }) {
                        Text(CREATE_TEXT)
                    }
                    Button(action: {
                        showingPopup.toggle()
                    }) {
                        Text(CANCEL_TEXT)
                    }
                }
                ScrollView(showsIndicators: true) {
                    VStack(alignment: .leading) {
                        ForEach(playlists.list.indices, id: \.self) { index in
                            PlaylistAddRowView(playlistId: playlists.list[index].id, persistentId: persistentId, showingPopup: $showingPopup) {
                                Text(playlists.list[index].name)
                            }
                            Divider()
                        }.padding(.leading, 10)
                    }
                }
                .frame(alignment: .top)
            } else {
                VStack {
                    Text(INPUT_TEXT)
                    TextField("", text: $name)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                    HStack {
                        Button(action: {
                            let playlistRegister = PlaylistRegister()

                            playlistRegister.create(persistentId: persistentId, name: name)
                            showingPopup.toggle()
                        }) {
                            Text(OK_TEXT)
                        }
                        Button(action: {
                            isCreate.toggle()
                        }) {
                            Text(CANCEL_TEXT)
                        }
                    }
                }
            }
        }
        .frame(maxWidth: .infinity)
        .padding(20)
        .background(Color.white)
        .padding(20)
        .onAppear() {
            playlists.load()
        }
    }
}
