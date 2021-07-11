//
//  ListNavBarView.swift
//  ThinMP
//
//  Created by tk on 2020/06/01.
//

import SwiftUI

struct ListNavBarView<Content>: View where Content: View {
    let top: CGFloat
    @Binding var rect: CGRect
    let content: () -> Content

    var body: some View {
        ZStack {
            self.createHeaderView()
            content()
                .frame(height: StyleConstant.Height.row)
                .padding(EdgeInsets(
                    top: top,
                    leading: 0,
                    bottom: 0,
                    trailing: 0
                ))
        }
        .frame(height: StyleConstant.Height.row + top, alignment: .bottom)
        .zIndex(1)
    }

    private func createHeaderView() -> some View {
        return HStack(alignment: .center) {
            Spacer()
        }
        .frame(height: StyleConstant.Height.row)
        .padding(.top, top)
        .background(Color(UIColor.secondarySystemBackground))
        .border(Color(UIColor.systemGray5), width: 1)
        .opacity(opacity())
        .animation(.easeInOut)
    }

    private func opacity() -> Double {
        if rect.origin.y >= 0 {
            return 0
        }

        return 1
    }
}
