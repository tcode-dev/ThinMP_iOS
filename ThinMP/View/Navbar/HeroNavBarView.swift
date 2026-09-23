//
//  HeroNavBarView.swift
//  ThinMP
//
//  Created by tk on 2020/01/19.
//

import SwiftUI

struct HeroNavBarView<Content: View>: View {
    /// 背景の material の上に重ねる色の濃さ
    private let backgroundOpacity = 0.1

    let primaryText: String?
    let width: CGFloat
    let top: CGFloat
    /// ヒーローのタイトルが潜り込んだか。HeroHeaderView が測る
    let isScrolledUnder: Bool
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
                .opacity(backgroundOpacity)
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
        .frame(width: max(0, width - StyleConstant.button * 2), height: StyleConstant.Height.row)
        .padding(.top, top)
        .padding(.horizontal, StyleConstant.button)
        .opacity(opacity)
    }

    private var opacity: Double {
        return isScrolledUnder ? 1 : 0
    }
}
