//
//  PermissionView.swift
//  ThinMP
//
//  Created by tk on 2023/09/11.
//

import SwiftUI
import MediaPlayer

struct PermissionView<Content>: View where Content: View {
    let content: () -> Content
    @State var isAllowed: Bool = false
    @State var isRequested: Bool = false

    init(content: @escaping () -> Content) {
        self.content = content
        _isAllowed = State(initialValue: MPMediaLibrary.authorizationStatus() == .authorized)
    }

    var body: some View {
        if isAllowed {
            content()
        } else {
            VStack {
                if isRequested {
                    Text(LocalizedStringKey(LabelConstant.permission))
                        .padding(.leading, StyleConstant.Padding.large)
                        .padding(.trailing, StyleConstant.Padding.large)
                }
            }.onAppear {
                MPMediaLibrary.requestAuthorization { status in
                    if status == .authorized {
                        isAllowed.toggle()
                    } else {
                        isRequested.toggle()
                    }
                }
            }
        }
    }
}
