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

    @State private var isCreate: Bool = false
    @State private var name: String = ""

    let persistentId: MPMediaEntityPersistentID
    @Binding var showingPopup: Bool

    var body: some View {
        VStack {
            if (!self.isCreate) {
                HStack {
                    Button(action: {
                        self.isCreate.toggle()
                    }) {
                        Text(CREATE_TEXT)
                    }
                    Button(action: {
                        self.showingPopup.toggle()
                    }) {
                        Text(CANCEL_TEXT)
                    }
                }
                //            ScrollView() {
                //            }
            } else {
                VStack {
                    Text(INPUT_TEXT)
                    TextField("", text: $name)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                    HStack {
                        Button(action: {
                            let playlistRegister = PlaylistRegister()
                            playlistRegister.add(persistentId: persistentId, name: name)
                            self.showingPopup.toggle()
                        }) {
                            Text(OK_TEXT)
                        }
                        Button(action: {
                            self.isCreate.toggle()
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
    }
}
