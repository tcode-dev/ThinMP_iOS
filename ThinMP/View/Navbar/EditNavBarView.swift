//
//  EditNavBarView.swift
//  ThinMP
//
//  Created by tk on 2021/04/30.
//

import SwiftUI

struct EditNavBarView<Content> : View where Content: View {
    private let heigt: CGFloat = 50

    let top: CGFloat
    let content: () -> Content

    var body: some View {
        content()
            .frame(height: heigt)
            .padding(EdgeInsets(
                top: top,
                leading: 0,
                bottom: 0,
                trailing: 0
            ))

            .frame(height: heigt + top, alignment: .bottom)
            .background(Color(UIColor.secondarySystemBackground))
            .border(Color(UIColor.systemGray5), width: 1)
            .zIndex(1)
    }
}
