//
//  HeroHeaderView.swift
//  ThinMP
//
//  Created by tk on 2020/01/23.
//

import SwiftUI

struct HeroHeaderView<Content>: View where Content: View {
    @Binding var headerRect: CGRect

    let width: CGFloat
    let height: CGFloat
    let top: CGFloat
    let bottom: CGFloat
    let primaryText: String?
    let secondaryText: String?
    let content: () -> Content

    let isLandscape = UIDevice.current.orientation.isLandscape
    let isPad = UIDevice.current.userInterfaceIdiom == .pad

    var body: some View {
        let size = isLandscape ? height + top + bottom : width
        let rate = isPad ? 0.85 : 0.75
        let primaryTextOffset = size * rate
        let secondaryTextOffset = primaryTextOffset + 40

        ZStack(alignment: .top) {
            content()
            createPrimaryTextView()
                .frame(height: StyleConstant.Height.row)
                // offset の内側で測ることで、ずらした後の位置(GeometryReader を子に置いた場合と同じ)が取れる
                .onGeometryChange(for: CGRect.self) { proxy in
                    proxy.frame(in: .global)
                } action: { rect in
                    headerRect = rect
                }
                .offset(y: primaryTextOffset)
            SecondaryTextView(secondaryText)
                .frame(width: abs(width - (StyleConstant.button * 2)), height: 25, alignment: .center)
                .offset(y: secondaryTextOffset)
                .padding(.leading, StyleConstant.button)
                .padding(.trailing, StyleConstant.button)
        }
        .frame(height: size)
    }

    /// PrimaryTextのViewを生成する
    /// 位置はこの View の onGeometryChange で親に渡し、ナビゲーションバーのタイトル表示の切り替えに使う
    private func createPrimaryTextView() -> some View {
        return VStack {
            TitleView(primaryText).opacity(textOpacity())
        }
        .frame(width: abs(width - (StyleConstant.button * 2)), height: StyleConstant.Height.row)
        .padding(.leading, StyleConstant.button)
        .padding(.trailing, StyleConstant.button)
    }

    private func textOpacity() -> Double {
        if headerRect.origin.y - top > 0 {
            return 1
        }

        return 0
    }
}
