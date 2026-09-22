//
//  PopupView.swift
//  ThinMP
//
//  Created by tk on 2021/04/04.
//

import SwiftUI

struct PopupView<Content: View>: View {
    @ViewBuilder let content: () -> Content

    var body: some View {
        content()
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
            .background(.ultraThinMaterial)
            .ignoresSafeArea(.container)
    }
}
