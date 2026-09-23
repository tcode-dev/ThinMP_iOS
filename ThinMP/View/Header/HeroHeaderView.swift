//
//  HeroHeaderView.swift
//  ThinMP
//
//  Created by tk on 2020/01/23.
//

import SwiftUI

/// 詳細ページ先頭のヒーロー。content(画像)の上にタイトルと説明(secondaryText)を重ねる
struct HeroHeaderView<Content: View, SecondaryText: View>: View {
    /// タイトルがナビゲーションバーの下に潜り込んだか。ここで測って親に渡し、ナビゲーションバーと共有する
    @Binding var isScrolledUnder: Bool

    let width: CGFloat
    /// ヒーロー画像の 1 辺(GeometryProxy.heroSize)
    let size: CGFloat
    let top: CGFloat
    let primaryText: String?
    @ViewBuilder let content: () -> Content
    /// 説明の行。ページごとにライブラリの文字列かラベルかが違うので、SecondaryTextView を作って渡す
    @ViewBuilder let secondaryText: () -> SecondaryText

    var body: some View {
        let rate = StyleConstant.isPad ? 0.85 : 0.75
        let primaryTextOffset = size * rate
        let secondaryTextOffset = primaryTextOffset + 40

        ZStack(alignment: .top) {
            content()
            primaryTextView
                .frame(height: StyleConstant.Height.row)
                // offset の内側で測ることで、ずらした後の位置(GeometryReader を子に置いた場合と同じ)が取れる
                // 位置そのものではなく判定結果を渡すので、State が変わるのは境目を越えたときだけになる
                .onGeometryChange(for: Bool.self) { proxy in
                    proxy.frame(in: .global).minY < top
                } action: { isScrolledUnder in
                    self.isScrolledUnder = isScrolledUnder
                }
                .offset(y: primaryTextOffset)
            secondaryText()
                .frame(width: max(0, width - StyleConstant.button * 2), height: 25, alignment: .center)
                .offset(y: secondaryTextOffset)
                .padding(.horizontal, StyleConstant.button)
        }
        .frame(height: size)
    }

    /// ヒーローの中に重ねるタイトル
    /// 潜り込んだかをこの View の onGeometryChange で親に渡し、ナビゲーションバーのタイトル表示の切り替えに使う
    private var primaryTextView: some View {
        return VStack {
            TitleView(primaryText).opacity(textOpacity)
        }
        .frame(width: max(0, width - StyleConstant.button * 2), height: StyleConstant.Height.row)
        .padding(.horizontal, StyleConstant.button)
    }

    /// ナビゲーションバーのタイトルと入れ替わるので、潜り込んだら消す
    private var textOpacity: Double {
        return isScrolledUnder ? 0 : 1
    }
}
