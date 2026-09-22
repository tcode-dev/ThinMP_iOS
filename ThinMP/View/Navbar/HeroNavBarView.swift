//
//  HeroNavBarView.swift
//  ThinMP
//
//  Created by tk on 2020/01/19.
//

import SwiftUI

struct HeroNavBarView<Content: View>: View {
    let primaryText: String?
    let width: CGFloat
    let top: CGFloat
    @Binding var headerRect: CGRect
    @ViewBuilder let content: () -> Content

    var body: some View {
        ZStack {
            HStack {
                BackButtonView()
                Spacer()
                content()
            }
            .frame(height: StyleConstant.Height.row)
            .padding(.top, top)
            .zIndex(3)
            headerView
            titleView
                .zIndex(2)
        }
        .frame(height: StyleConstant.Height.row + top)
        .zIndex(1)
    }

    /// 潜り込んだときだけ出るナビゲーションバーの背景
    private var headerView: some View {
        return VStack {
            Rectangle().frame(width: width, height: StyleConstant.Height.row + top)
                .opacity(0.1)
        }
        .background(.thinMaterial)
        .opacity(opacity)
        .animation(.easeInOut, value: opacity)
    }

    /// 潜り込んだときだけ出るナビゲーションバーのタイトル
    private var titleView: some View {
        return HStack(alignment: .center) {
            TitleView(primaryText)
        }
        .frame(width: abs(width - (StyleConstant.button * 2)), height: StyleConstant.Height.row)
        .padding(.top, top)
        .padding(.horizontal, StyleConstant.button)
        .opacity(opacity)
    }

    private var opacity: Double {
        return headerRect.isScrolledUnder(top: top) ? 1 : 0
    }
}
