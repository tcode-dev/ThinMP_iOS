//
//  PopupView.swift
//  ThinMP
//
//  Created by tk on 2021/04/04.
//

import SwiftUI

struct PopupView<Content> : View where Content: View {
    @Binding var showingPopup: Bool
    let content: () -> Content

    var body: some View {
        VStack {
            content()
        }
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
        .background(BlurView(style: .systemUltraThinMaterialLight))
        .edgesIgnoringSafeArea(.all)
    }
}
