//
//  MenuButtonView.swift
//  ThinMP
//
//  Created by tk on 2020/01/24.
//

import SwiftUI

struct MenuButtonView: View {
    @State var isOpen: Bool = false

    var body: some View {
        Button(action: {
            self.isOpen.toggle()
        }) {
            Image("MenuButton")
                .renderingMode(.original)
                .frame(width: 50, height: 50)
        }
        .actionSheet(isPresented: $isOpen) {
            ActionSheet(title: Text("What action?"),
                        message: Text("Pick one"),
                        buttons: [
                            .default(Text("Option 1"), action: {
                                NSLog("clicked Option 1")
                            }),
                            .default(Text("Option 2"), action: {
                                NSLog("clicked Option 2")
                            }),
                            .cancel()
            ])
        }
        .frame(width: 50, height: 50)
    }
}
