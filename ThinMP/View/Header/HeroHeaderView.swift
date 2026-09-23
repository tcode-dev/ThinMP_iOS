//
//  HeroHeaderView.swift
//  ThinMP
//
//  Created by tk on 2020/01/23.
//

import SwiftUI

/// 詳細ページ先頭のヒーロー。content(画像)の上にタイトルと説明(secondaryText)を重ねる
struct HeroHeaderView<Content: View, SecondaryText: View>: View {
    /// タイトルの上端から説明の上端まで
    private let secondaryTextSpacing: CGFloat = 40
    private let secondaryTextHeight: CGFloat = 25
    /// タイトルの上端の位置。ヒーロー画像の 1 辺に対する割合で、iPad は少し下げる
    private let primaryTextRate: CGFloat = StyleConstant.isPad ? 0.85 : 0.75

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
        let primaryTextOffset = size * primaryTextRate
        let secondaryTextOffset = primaryTextOffset + secondaryTextSpacing

        ZStack(alignment: .top) {
            content()
            primaryTextView
                // offset の内側で測ることで、ずらした後の位置(GeometryReader を子に置いた場合と同じ)が取れる
                // 位置そのものではなく判定結果を渡すので、State が変わるのは境目を越えたときだけになる
                .onGeometryChange(for: Bool.self) { proxy in
                    proxy.frame(in: .global).minY < top
                } action: { isScrolledUnder in
                    self.isScrolledUnder = isScrolledUnder
                }
                .offset(y: primaryTextOffset)
            secondaryText()
                .betweenSideButtons(width: width, height: secondaryTextHeight)
                .offset(y: secondaryTextOffset)
        }
        .frame(height: size)
    }

    /// ヒーローの中に重ねるタイトル
    /// 潜り込んだかをこの View の onGeometryChange で親に渡し、ナビゲーションバーのタイトル表示の切り替えに使う
    private var primaryTextView: some View {
        return TitleView(primaryText)
            .opacity(textOpacity)
            .betweenSideButtons(width: width, height: StyleConstant.Height.row)
    }

    /// ナビゲーションバーのタイトルと入れ替わるので、潜り込んだら消す
    private var textOpacity: Double {
        return isScrolledUnder ? 0 : 1
    }
}
