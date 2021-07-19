//
//  DetaiNavBarView.swift
//  ThinMP
//
//  Created by tk on 2020/01/19.
//

import MediaPlayer
import SwiftUI

struct DetaiNavBarView<Content>: View where Content: View {
    let primaryText: String?
    let side: CGFloat
    let top: CGFloat
    @Binding var headerRect: CGRect
    let content: () -> Content

    var body: some View {
        ZStack {
            HStack {
                BackButtonView()
                Spacer()
                content()
            }
            .frame(height: StyleConstant.Height.row)
            .padding(EdgeInsets(
                top: top,
                leading: 0,
                bottom: 0,
                trailing: 0
            ))
            .zIndex(3)
            createHeaderView()
            createTitleView()
                .zIndex(2)
        }
        .frame(height: StyleConstant.Height.row + top)
        .zIndex(1)
    }

    private func createHeaderView() -> some View {
        return VStack {
            Rectangle().frame(width: side, height: StyleConstant.Height.row + top)
                .opacity(0.1)
        }
        .background(BlurView(style: .systemThinMaterial))
        .opacity(opacity())
        .animation(.easeInOut)
    }

    private func createTitleView() -> some View {
        return HStack(alignment: .center) {
            TitleView(primaryText)
        }
        .frame(width: abs(side - (StyleConstant.button * 2)), height: StyleConstant.Height.row)
        .padding(EdgeInsets(
            top: top,
            leading: StyleConstant.button,
            bottom: 0,
            trailing: StyleConstant.button
        ))
        .opacity(opacity())
    }

    private func opacity() -> Double {
        // ページ遷移直後は位置を取得できていない
        if headerRect == CGRect.zero {
            return 0
        }
        if headerRect.origin.y - top > 0 {
            return 0
        }

        return 1
    }
}
