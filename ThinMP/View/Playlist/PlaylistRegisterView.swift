//
//  PlaylistRegisterView.swift
//  ThinMP
//
//  Created by tk on 2021/04/01.
//

import SwiftUI

struct PlaylistRegisterView: View {
    private let CREATE_TEXT: String = "プレイリストを作成"
    private let CANCEL_TEXT: String = "CANCEL"
    @Environment(\.presentationMode) var presentation

    var body: some View {
        HStack {
            Button(action: {
                self.presentation.wrappedValue.dismiss()
            }) {
                Text(CREATE_TEXT)
            }
            Button(action: {
                self.presentation.wrappedValue.dismiss()
            }) {
                Text(CANCEL_TEXT)
            }
        }
    }
}
